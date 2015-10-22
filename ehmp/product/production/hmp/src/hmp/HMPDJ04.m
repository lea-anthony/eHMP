HMPDJ04 ;SLC/MKB -- Appointments,Visits ;6/25/12  16:11
 ;;2.0;ENTERPRISE HEALTH MANAGEMENT PLATFORM;**1**;Sep 01, 2011;Build 11
 ;;Per VHA Directive 2004-038, this routine should not be modified.
 ;
 ; External References          DBIA#
 ; -------------------          -----
 ; ^AUPNVSIT                     2028
 ; ^DGS(41.1                     3796
 ; ^DIC(42                      10039
 ; ^SC                          10040
 ; ^VA(200                      10060
 ; DIQ                           2056
 ; ICPTCOD                       1995
 ; PXAPI,^TMP("PXKENC"           1894
 ; SDAMA301                      4433
 ; XLFDT                        10103
 ; XUAF4                         2171
 ;
 ; All tags expect DFN, ID, [HMPSTART, HMPSTOP, HMPMAX, HMPTEXT]
 ;
SDAM1 ; -- appointment ^TMP($J,"SDAMA301",DFN,HMPDT)
 N NODE,HLOC,APPT,X,STS,CLS,FAC,SV,PRV
 S NODE=$G(^TMP($J,"SDAMA301",DFN,HMPDT))
 N $ES,$ET,ERRPAT,ERRMSG
 S $ET="D ERRHDLR^HMPDERRH",ERRPAT=DFN
 S ERRMSG="A problem occurred converting a record for the appointment domain"
 ;
 S HLOC=$P(NODE,U,2),X="A;"_HMPDT_";"_+HLOC
 I $L($G(ID)),$P(ID,";",1,3)'=X Q
 S APPT("localId")=X,APPT("uid")=$$SETUID^HMPUTILS("appointment",DFN,X)
 S X=$P(NODE,U,10),APPT("typeCode")=$P(X,";"),APPT("typeName")=$P(X,";",2)
 S STS=$P(NODE,U,3),CLS=$S($E(STS)="I":"I",1:"O")
 S APPT("dateTime")=$$JSONDT^HMPUTILS(HMPDT)
 S:$L($P(NODE,U,6)) APPT("comment")=$P(NODE,U,6)
 S:$P(NODE,U,9) APPT("checkIn")=$$JSONDT^HMPUTILS($P(NODE,U,9))
 S:$P(NODE,U,11) APPT("checkOut")=$$JSONDT^HMPUTILS($P(NODE,U,11))
 I $L(ID,";")>3 S APPT("reasonName")=$P(ID,";",4),PRV=+$P(ID,";",5) ;from SDAM event
 S FAC=$$FAC^HMPD(+HLOC) D FACILITY^HMPUTILS(FAC,"APPT") I HLOC D
 . S APPT("locationName")=$P(HLOC,";",2)
 . S APPT("locationUid")=$$SETUID^HMPUTILS("location",,+HLOC)
 . S X=$P($G(^SC(+HLOC,0)),U,2) S:X]"" APPT("shortLocationName")=X
 . S X=$$AMIS^HMPDVSIT(+$P(NODE,U,13))
 . S:$L(X) APPT("stopCodeUid")="urn:va:stop-code:"_$P(X,U),APPT("stopCodeName")=$P(X,U,2)
 . S SV=$$GET1^DIQ(44,+HLOC_",",9.5,"I")
 . I SV S APPT("service")=$$SERV^HMPDSDAM(SV)
 . ;find default provider
 . S:'$G(PRV) PRV=+$$GET1^DIQ(44,+HLOC_",",16,"I") I 'PRV D
 .. N HMPP,I,FIRST
 .. D GETS^DIQ(44,+HLOC_",","2600*","I","HMPP")
 .. S FIRST=$O(HMPP(44.1,"")),I=""
 .. F  S I=$O(HMPP(44.1,I)) Q:I=""  I $G(HMPP(44.1,I,.02,"I")) S PRV=$G(HMPP(44.1,I,.01,"I")) Q
 .. I 'PRV,FIRST S PRV=$G(HMPP(44.1,FIRST,.01,"I"))
 I $G(PRV) S APPT("providers",1,"providerUid")=$$SETUID^HMPUTILS("user",,PRV),APPT("providers",1,"providerName")=$P($G(^VA(200,PRV,0)),U)
 S APPT("patientClassCode")="urn:va:patient-class:"_$S(CLS="I":"IMP",1:"AMB")
 S APPT("patientClassName")=$S(CLS="I":"Inpatient",1:"Ambulatory")
 S APPT("categoryCode")="urn:va:encounter-category:OV",APPT("categoryName")="Outpatient Visit"
 S APPT("appointmentStatus")=$P(STS,";",2)
 S APPT("lastUpdateTime")=$$EN^HMPSTMP("appointment") ;RHL 20150102
 S APPT("stampTime")=APPT("lastUpdateTime") ; RHL 20150102
 ;US6734 - pre-compile metastamp
 I $G(HMPMETA)=1 D ADD^HMPMETA("appointment",APPT("uid"),APPT("stampTime")) Q  ;US6734
 D ADD^HMPDJ("APPT","appointment")
 Q
 ;
DGS ; scheduled admissions [from APPOINTM^HMPDJ0]
 S HMPA=0 F  S HMPA=$O(^DGS(41.1,"B",DFN,HMPA)) Q:HMPA<1  D  Q:HMPI'<HMPMAX
 . S HMPX=$G(^DGS(41.1,HMPA,0))
 . I $L($G(ID)),+$P(ID,";",2)=+$P(HMPX,U,2) D DGS1(HMPA) Q
 . Q:$P(HMPX,U,13)  Q:$P(HMPX,U,17)  ;cancelled or admitted
 . S X=$P(HMPX,U,2) Q:X<HMPSTART!(X>HMPSTOP)  ;out of date range
 . D DGS1(HMPA)
 Q
 ;
DGS1(IFN) ; -- scheduled admission
 N ADM,X0,DATE,HLOC,FAC,SV,X
 S X0=$G(^DGS(41.1,+$G(IFN),0)) Q:X0=""  ;deleted
 ;
 S DATE=+$P(X0,U,2),HLOC=+$G(^DIC(42,+$P(X0,U,8),44))
 S X="H;"_DATE,ADM("localId")=X,ADM("uid")=$$SETUID^HMPUTILS("appointment",DFN,X)
 S ADM("dateTime")=$$JSONDT^HMPUTILS(DATE)
 S FAC=$$FAC^HMPD(+HLOC) D FACILITY^HMPUTILS(FAC,"ADM") I HLOC D
 . S HLOC=+HLOC_";"_$P($G(^SC(+HLOC,0)),U)
 . S ADM("uid")=ADM("uid")_";"_+HLOC
 . S ADM("locationName")=$P(HLOC,";",2)
 . S X=$P($G(^SC(+HLOC,0)),U,2) S:X]"" ADM("shortLocationName")=X
 . S ADM("locationUid")=$$SETUID^HMPUTILS("location",,+HLOC)
 . S X=$$GET1^DIQ(44,+HLOC_",",8,"I"),X=$$AMIS^HMPDVSIT(X)
 . S:$L(X) ADM("stopCodeUid")="urn:va:stop-code:"_$P(X,U),ADM("stopCodeName")=$P(X,U,2)
 . S SV=$$GET1^DIQ(44,+HLOC_",",9.5,"I")
 . I SV S ADM("service")=$$SERV^HMPDSDAM(SV)
 S X=+$P(X0,U,5) I X D
 . S ADM("providers",1,"providerUid")=$$SETUID^HMPUTILS("user",,X)
 . S ADM("providers",1,"providerName")=$P($G(^VA(200,X,0)),U)
 S ADM("patientClassCode")="urn:va:patient-class:IMP",ADM("patientClassName")="Inpatient"
 S ADM("categoryCode")="urn:va:encounter-category:AD",ADM("categoryName")="Admission"
 S ADM("appointmentStatus")=$S($P(X0,U,17):"ADMITTED",$P(X0,U,13):"CANCELLED",1:"SCHEDULED")
 S ADM("lastUpdateTime")=$$EN^HMPSTMP("adm") ;RHL 20150102
 S ADM("stampTime")=ADM("lastUpdateTime") ; RHL 20150102
 ;US6734 - pre-compile metastamp
 I $G(HMPMETA)=1 D ADD^HMPMETA("appointment",ADM("uid"),ADM("stampTime")) Q  ;US6734
 D ADD^HMPDJ("ADM","appointment")
 Q
 ;
VSIT1(ID) ; -- visit
 N VST,X0,X15,X,FAC,LOC,CATG,AMIS,INPT,DA,PS
 I $G(ID)?1"H"1.N D ADM^HMPDJ04A(ID) Q
 I $D(^EDP(230,"V",ID)),$L($T(EDP1^HMPDJ04E)) D EDP1^HMPDJ04E(ID) Q
 ; ENCEVENT^PXAPI(ID)
 ;
 S X0=$G(^AUPNVSIT(ID,0)),X15=$G(^(150)) Q:X0=""  ;pjh - quit if visit already deleted
 ; X0=$G(^TMP("PXKENC",$J,ID,"VST",ID,0)),X15=$G(^(150))
 ;Q:$P(X15,U,3)'="P"  Q:$P(X0,U,7)="E"  Q:$P(X0,U,12)  ;primary, not historical or child
 I $P(X0,U,7)="H" D ADM^HMPDJ04A(ID,+X0) Q
 S VST("localId")=ID,VST("uid")=$$SETUID^HMPUTILS("visit",DFN,ID)
 S VST("dateTime")=$$JSONDT^HMPUTILS(+X0)
 S:$P(X0,U,18) VST("checkOut")=$$JSONDT^HMPUTILS($P(X0,U,18))
 S:$P(X0,U,12) VST("parentUid")=$$SETUID^HMPUTILS("visit",DFN,$P(X0,U,12))
 S FAC=+$P(X0,U,6),CATG=$P(X0,U,7),LOC=+$P(X0,U,22)
 S:FAC X=$$STA^XUAF4(FAC)_U_$P($$NS^XUAF4(FAC),U)
 S:'FAC X=$$FAC^HMPD(LOC) D FACILITY^HMPUTILS(X,"VST")
 S X=$S(CATG="H":"AD",CATG="C":"CR",CATG="T":"TC",CATG="N":"U",CATG="R":"NH","D^X"[CATG:"O",1:"OV")
 S VST("categoryCode")="urn:va:encounter-category:"_X
 S VST("categoryName")=$S(X="AD":"Admission",X="CR":"Chart Review",X="TC":"Phone Contact",X="U":"Unknown",X="NH":"Nursing Home",X="O":"Other",1:"Outpatient Visit")
 S INPT=$P(X15,U,2) S:INPT="" INPT=$S("H^I^R^D"[CATG:1,1:0)
 S X=$P(X15,U,3) S:$L(X) VST("encounterType")=X
 S X=$$CPT(ID) S:X VST("typeName")=$P($$CPT^ICPTCOD(X),U,3)
 I 'X S VST("typeName")=$S('INPT&LOC:$P($G(^SC(LOC,0)),U)_" VISIT",1:$$CATG^HMPDVSIT(CATG))
 S VST("patientClassCode")="urn:va:patient-class:"_$S(INPT:"IMP",1:"AMB")
 S VST("patientClassName")=$S(INPT:"Inpatient",1:"Ambulatory")
 S X=$P(X0,U,8) S:X AMIS=$$AMIS^HMPDVSIT(X) I LOC D
 . N L0 S L0=$G(^SC(LOC,0))
 . I 'X S AMIS=$$AMIS^HMPDVSIT($P(L0,U,7))
 . S VST("locationUid")=$$SETUID^HMPUTILS("location",,+LOC)
 . S X=$P($G(^SC(+LOC,0)),U,2) S:X]"" VST("shortLocationName")=X
 . S VST("locationName")=$P(L0,U),VST("locationOos")=$S(+$G(^SC(+LOC,"OOS")):"true",1:"false")
 . S X=$$SERV^HMPDVSIT($P(L0,U,20)) S:$L(X) VST("service")=X
 S:$D(AMIS) VST("stopCodeUid")="urn:va:stop-code:"_$P(AMIS,U),VST("stopCodeName")=$P(AMIS,U,2)
 S X=$$POV(ID) S:$L(X) VST("reasonUid")=$$SETNCS^HMPUTILS("icd",$P(X,U)),VST("reasonName")=$P(X,U,2)
 ; provider(s)
 S DA=0 F  S DA=$O(^AUPNVPRV("AD",ID,DA)) Q:DA<1  D
 . S X0=$G(^AUPNVPRV(DA,0))
 . I $P(X0,U,4)="P" D PROV("VST",DA,+X0,"P",1) Q  ;primary
 . D:'$D(PS(+X0)) PROV("VST",DA,+X0,"S")          ;secondary
 . S PS(+X0)=""                                   ; (no duplicates)
 K ^TMP("PXKENC",$J,ID)
 S VST("lastUpdateTime")=$$EN^HMPSTMP("visit") ;RHL 20150103
 S VST("stampTime")=VST("lastUpdateTime") ; RHL 20150103
 ;US6734 - pre-compile metastamp
 I $G(HMPMETA)=1 D ADD^HMPMETA("visit",VST("uid"),VST("stampTime")) Q  ;US6734
 D ADD^HMPDJ("VST","visit")
 Q
 ;
CPT(VISIT) ; -- Return CPT code of encounter type
 N DA,Y,X S Y=""
 S DA=0 F  S DA=$O(^AUPNVCPT("AD",VISIT,DA)) Q:DA<1  D  Q:$L(Y)
 . S X=$P($G(^AUPNVCPT(DA,0)),U) I X?1"992"2N S Y=X Q
 Q Y
 ;
POV(VISIT) ; -- return the primary Purpose of Visit as ICD^ProviderNarrative
 N DA,Y,X,X0,ICD S Y=""
 S DA=0 F  S DA=$O(^AUPNVPOV("AD",VISIT,DA)) Q:DA<1  D  Q:$L(Y)
 . S X0=$G(^AUPNVPOV(DA,0)) Q:$P(X0,U,12)'="P"
 . S X=+$P(X0,U,4),ICD=$$ICD^HMPDVSIT(+X0)
 . S Y=ICD_U_$$EXTERNAL^DILFD(9000010.07,.04,,X)
 Q Y
 ;
PROV(ARR,I,IEN,ROLE,PRIM) ; -- add providers
 S @ARR@("providers",I,"providerUid")=$$SETUID^HMPUTILS("user",,+IEN)
 S @ARR@("providers",I,"providerName")=$P($G(^VA(200,+IEN,0)),U)
 S @ARR@("providers",I,"role")=ROLE
 S:$G(PRIM) @ARR@("providers",I,"primary")="true"
 Q
 ;
NAME(IEN) ; -- Return a string 'name' for the visit
 N Y,X0,LOC,DATE
 S X0=$G(^AUPNVSIT(+$G(IEN),0)),Y=""
 S DATE=+X0,LOC=+$P(X0,U,22) S:LOC LOC=$P($G(^SC(LOC,0)),U)_" "
 S Y=LOC_$$FMTE^XLFDT(DATE,"1D") ;Mon DD, YYYY
 Q Y
 ;
FAC(IEN)  ; -- Return Facility for the visit
 Q:'+$G(IEN) ""
 N FAC S FAC=+$$GET1^DIQ(9000010,IEN_",",.06,"I")
 Q:FAC $$STA^XUAF4(FAC)_U_$P($$NS^XUAF4(FAC),U)
 S FAC=+$$GET1^DIQ(9000010,IEN_",",.22,"I")
 Q $$FAC^HMPD(FAC)
 ;
STCODE(IEN)  ;  -- Return stop code information for the visit Q:'+$G(IEN) ""
 Q:'+$G(IEN) ""
 N STCODE,LIEN S STCODE=+$$GET1^DIQ(9000010,IEN_",",.08,"I")
 Q:STCODE $$AMIS^HMPDVSIT(STCODE)
 S LIEN=+$$GET1^DIQ(9000010,IEN_",",.22,"I")
 I LIEN S STCODE=+$$GET1^DIQ(44,LIEN_",",8,"I")
 Q:STCODE $$AMIS^HMPDVSIT(STCODE)
 Q ""
 ;
STOPCODE(X,Y)  ;  -- Return stop code info for JSON
 S @Y@("stopCodeUid")="urn:va:stop-code:"_$P(X,U)
 S @Y@("stopCodeName")=$P(X,U,2)
 Q
 ;
