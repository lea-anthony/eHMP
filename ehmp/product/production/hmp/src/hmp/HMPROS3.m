HMPROS3 ;SLC/GRR -- Roster Management ;4/24/2012
 ;;2.0;ENTERPRISE HEALTH MANAGEMENT PLATFORM;**1**;AUG 17, 2011;Build 49
PREVIEW(HMP,HMPARRAY) ;; Previews what a roster would look like as defined
 ;;  Called by the GUI Roster Builder
 ;; Input - HMPARRAY - contains roster data entered thru GUI
 K HMPLIST,HMPLIST2
 N %,BEG,DA,DIDEL,DIE,DOB,SSN,DR,END,GENDER,ICN,NAME,HMPC,HMPCIEN,HMPDIS,HMPDNAME,HMPDOB,HMPDT,HMPIII,HMPLIEN,HMPOIEN,HMPOWNID
 N HMPOWNNM,HMPPAT,HMPPIEN,HMPPNME,HMPRCNT,HMPRID,HMPTEXT,HMPTIEN,HMPLST,HMPVAR,HMPVER,HMPWIEN,HMPWNAME,HMPZ,X,Y
 N HMPFILT,HMPI,HMPNLIST,HMPSRCID,HMPTAG,HMPTLST,HMPY,HMPTYPE,ZZ
 N HMPSYS S HMPSYS=$$GET^XPAR("SYS","HMP SYSTEM NAME")
 S (HMPLIST,HMPFILT,HMPTYPE,HMPOP,HMPLIST2,VPERR)="",HMPI=0
 S HMP=$NA(^TMP($J,"HMPROSTR")) ; kcm -- moved this here so HMP gets defined
 K ^TMP($J,"HMPROSTR")
 I $O(HMPARRAY(""))="" S @HMP@(1)="0^No roster data passed" Q
 Q:'$$VALIDATE
 D NOW^%DTC S HMPDT=%
 S HMPZ="" S HMPZ=$O(HMPARRAY(HMPZ)) I HMPZ="" Q
 S HMPNLIST=""
 S HMPRNAME=$P(HMPARRAY(HMPZ),"^",1),HMPRNAME=$$ESC^HMPD(HMPRNAME)
 S HMPDNAME=$P(HMPARRAY(HMPZ),"^",3),HMPDNAME=$$ESC^HMPD(HMPDNAME)
 S HMPDIS=$P(HMPARRAY(HMPZ),"^",4)
 S HMPOWNID=$P(HMPARRAY(HMPZ),"^",5)
 S HMPOWNNM=$P($G(^VA(200,HMPOWNID,0)),"^",1),HMPOWNNM=$$ESC^HMPD(HMPOWNNM)
 F  S HMPZ=$O(HMPARRAY(HMPZ)) Q:HMPZ=""  D
 . S HMPY=HMPARRAY(HMPZ)
 . S HMPOP=$P(HMPY,"^",2)
 . S HMPTAG=$P(HMPY,"^",1)
 . S HMPLAB=""
 . I HMPTAG["Clinic" S HMPLAB="CLIN"
 . I HMPTAG["Ward" S HMPLAB="WARD"
 . I HMPTAG["Patient" S HMPLAB="PAT"
 . I HMPTAG["PCMM Team" S HMPLAB="PCMM"
 . I HMPTAG["OE/RR" S HMPLAB="CPRS"
 . I HMPTAG["HMP Roster" S HMPLAB="ROST"
 . I HMPTAG["Specialty" S HMPLAB="SPEC"
 . I HMPTAG["Provider" S HMPLAB="PROV"
 . I HMPTAG["PXRM" S HMPLAB="PXRM"
 . I HMPLAB="" S @HMP@(1)="1^INVALID FILE TYPE" Q
 . D @HMPLAB
 . S HMPLAB=$S(HMPOP="UNION":"UNION",HMPOP="Intersection":"INTER",1:"DIFF")
 . S HMPNLIST=""
 . D @HMPLAB
 I $D(HMPOUT) K HMPOUT M HMPLIST2=HMPLIST Q
 I $O(HMPLIST(0))'>0 S @HMP@(1)="1^EMPTY ROSTER" Q
 D SEND
 D ENROS^HMPFPTC(.ZZ,HMPLIST) ;added 5/17/12 grr to check patient sensitivity
 Q
 ;
CLIN ;Process patients for this clinic.  Select all if filter is null
 K HMPLIST2,HMPOUT S HMPLIST2=""
 I '$D(DT) S DT=$$DT^XLFDT()
 S BEG=DT,END=$S(HMPFILT="T":DT+.24,1:9999999+.24),HMPIII=BEG
 S HMPCIEN=+$P(HMPY,"^",3) F  S HMPIII=$O(^SC(HMPCIEN,"S",HMPIII)) Q:HMPIII'>0!(HMPIII>END)  D
 . S HMPII=0 F  S HMPII=$O(^SC(HMPCIEN,"S",HMPIII,1,HMPII)) Q:HMPII'>0  S DFN=$P($G(^SC(HMPCIEN,"S",HMPIII,1,HMPII,0)),"^",1) I DFN>0 D
 . .S HMPLIST2(DFN)=""
 Q
 ;
WARD ;Process patients for this ward
 K HMPLIST2,HMPOUT S HMPLIST2=""
 S HMPWIEN=+$P(HMPY,"^",3),HMPWNAME=$P($G(^DIC(42,HMPWIEN,0)),"^",1)
 S HMPIII=0 F  S HMPIII=$O(^DGPM("CN",HMPWNAME,HMPIII)) Q:HMPIII'>0  D
 . S DFN=$P($G(^DGPM(HMPIII,0)),"^",3),HMPLIST2(DFN)=""
 Q
 ;
PAT ;Process patient from Patient file Source
 K HMPLIST2,HMPOUT S HMPLIST2=""
 S DFN=+$P(HMPY,"^",3),HMPLIST2(DFN)=""
 Q
 ;
PCMM ;Process patients from a PCMM team
 K HMPLIST2,HMPOUT S HMPLIST2=""
 S HMPTIEN=+$P(HMPY,"^",3),VPERR="",HMPTLST=""
 D PTTM^SCAPMC(HMPTIEN,,"HMPTLST",VPERR)
 S HMPIII="" F  S HMPIII=$O(HMPTLST(HMPIII)) Q:HMPIII'>0  S DFN=$P(HMPTLST(HMPIII),"^",1) S HMPLIST2(DFN)=""
 Q
 ;
CPRS ;Process patients from CPRS Lists
 K HMPLIST2,HMPOUT S HMPLIST2=""
 S HMPOIEN=+$P(HMPY,"^",3),VPERR=""
 S HMPIII=0 F  S HMPIII=$O(^OR(100.21,HMPOIEN,10,HMPIII)) Q:HMPIII'>0  S DFN=$P(^OR(100.21,HMPOIEN,10,HMPIII,0),";",1) S HMPLIST2(DFN)=""
 Q
 ;
ROST ;Process patients from selected roster
 N HMP,HMPIEN,VPERR
 S HMPIEN=+$P(HMPY,"^",3),VPERR="",HMPOUT=1
 D COMPILE^HMPROS2(.HMP,HMPIEN,"")
 M HMPLIST=HMPLIST2
 K HMPOUT
 Q
 ;
SPEC ;Process patients with selected Treating Specialty
 K HMPLIST2,HMPOUT S HMPLIST2=""
 S HMPOIEN=+$P(HMPY,"^",3),VPERR=""
 N DFN S DFN=0 F  S DFN=$O(^DPT("ATR",HMPOIEN,DFN)) Q:DFN'>0  S HMPLIST2(DFN)=""
 Q
 ;
PROV ;Process patients for selected provider
 K HMPLIST2,HMPOUT S HMPLIST2=""
 S HMPPIEN=+$P(HMPY,"^",3),VPERR=""
 N DFN S DFN=0 F  S DFN=$O(^DPT("APR",HMPPIEN,DFN)) Q:DFN'>0  S HMPLIST2(DFN)=""
 Q
 ;
PXRM ;Process patients for selected panel
 K HMPLIST2,HMPOUT,HMPPAT,HMPRIEN S HMPLIST2=""
 S HMPPIEN=+$P(HMPY,"^",3),VPERR="",HMPLIEN=$P($G(^PXRM(810.4,HMPPIEN,0)),"^",1) I HMPLIEN="" S @HMP@(1)="Invalid PXRM" Q
 ;S HMPRIEN=$O(^HMPROSTR("B",HMPRNAME,"")) I HMPRIEN'>0 S @HMP@(1)="Invalid PXRM" Q
 ;S HMPPNME=$P(^HMPROSTR(HMPRIEN,0),"^",6)
 S HMPC=HMPPIEN
 S HMPPAT="" D RUNLIST^HMPROS5(.HMPPAT,HMPPIEN,HMPRNAME,0,1)
 S HMPII=0 F  S HMPII=$O(HMPPAT(HMPC,HMPII)) Q:HMPII'>0  S DFN=HMPPAT(HMPC,HMPII),HMPLIST2(DFN)=""
 Q
 ;
UNION ;Add to existing list
 S HMPII=0 F  S HMPII=$O(HMPLIST2(HMPII)) Q:HMPII'>0  S HMPLIST(HMPII)=""
 Q
 ;
INTER ;Intersect with existing list
 S HMPII=0 F  S HMPII=$O(HMPLIST(HMPII)) Q:HMPII'>0  D
 . I '$D(HMPLIST2(HMPII)) K HMPLIST(HMPII)
 Q
 ;
DIFF ;Remove patients from this source that we have so far or add new one
 S HMPII=0 F  S HMPII=$O(HMPLIST2(HMPII)) Q:HMPII'>0  D
 . I '$D(HMPLIST(HMPII)) S HMPLIST(HMPII)=""
 . E  K HMPLIST(HMPII)
 Q
 ;
SEND ;send pending rosters.  Called through RPC
 S HMPRCNT=0,HMPI=0,HMPII=0
 S HMPVER="<results version='"_$P($T(HMPROS3+1),";",3)_"'>"
 D ADD(HMPVER)
 ;S HMPRNAME=$P(^HMPROSTR(HMPIEN,0),"^",1),HMPDNAME=$P(^HMPROSTR(HMPIEN,0),"^",2)
 S HMPTEXT="<roster ien='' ownername='"_HMPOWNNM_"'  ownerid='"_HMPOWNID_"'>" D ADD(HMPTEXT)
 S HMPTEXT="<rosterName>"_HMPRNAME_"</rosterName>" D ADD(HMPTEXT)
 S HMPTEXT="<displayName>"_HMPDNAME_"</displayName>" D ADD(HMPTEXT)
 D ADD("<patients>")
 K HMPII S HMPII=0 F  S HMPII=$O(HMPLIST(HMPII)) Q:HMPII'>0  D 
 . S DFN=HMPII
 . S ICN=$$GETICN^MPIF001(DFN)
 . S NAME=$P(^DPT(DFN,0),"^",1),GENDER=$P(^DPT(DFN,0),"^",2),SSN=$P(^DPT(DFN,0),"^",9),DOB=$P(^DPT(DFN,0),"^",3),HMPDOB=$$FMTHL7^XLFDT(DOB)
 . S Y="<patient name='"_NAME_"' gender='"_GENDER_"' dob='"_HMPDOB_"' ssn='"_SSN_"' id='"_DFN_$S(ICN:"' icn='"_ICN,1:"")_"' />" D ADD(Y)
 D ADD("</patients>")
 D ADD("</roster>")
 S HMPTEXT="</results>" D ADD(HMPTEXT)
 Q
 ;
 ;
ADD(X) ; -- Add a line @HMP@(n)=X
 S HMPI=$G(HMPI)+1
 S @HMP@(HMPI)=X
 Q
 ;
UPDATE(HMP,HMPARRAY) ;;Update Roster data with data from GUI
 N HMPZ,HMPRNAME,HMPID,HMPDNAME,HMPDIS,HMPRID,FDA,HMPOWNID,HMPSRCID,HMPOP,HMPSRCNM,HMPLAB,HMPVAR,BEFORE,AFTER
 N HMPSYS S HMPSYS=$$GET^XPAR("SYS","HMP SYSTEM NAME")
 S HMP=$NA(^TMP($J,"HMPROSTR"))
 Q:'$$VALIDATE
 D NOW^%DTC S HMPDT=% ;added 5/11/12 grr for tracing
 S HMPZ="" S HMPZ=$O(HMPARRAY(HMPZ)) Q:HMPZ=""
 S HMPRNAME=$P(HMPARRAY(HMPZ),"^",1),HMPRID=$P(HMPARRAY(HMPZ),"^",2),HMPDNAME=$P(HMPARRAY(HMPZ),"^",3),HMPDIS=$P(HMPARRAY(HMPZ),"^",4),HMPOWNID=$P(HMPARRAY(HMPZ),"^",5)
 D:HMPRID>0 BEFORE
 I HMPRID="" D ADDROS
 I '$D(^HMPROSTR(HMPRID,0)) S @HMP@(1)="RosterID passed was invalid" Q
 S FDA(1,800001.2,""_HMPRID_","_"",.01)=HMPRNAME
 S FDA(1,800001.2,""_HMPRID_","_"",.02)=HMPDNAME
 S FDA(1,800001.2,""_HMPRID_","_"",.03)=HMPDIS
 S FDA(1,800001.2,""_HMPRID_","_"",.04)=HMPOWNID
 S FDA(1,800001.2,""_HMPRID_","_"",99)=HMPDT
 D UPDATE^DIE("","FDA(1)")
 K ^HMPROSTR(HMPRID,1),FDA
 F  S HMPZ=$O(HMPARRAY(HMPZ)) Q:HMPZ=""  D
 . S HMPY=HMPARRAY(HMPZ)
 . S HMPSRCID=$P(HMPY,"^",3)
 . S HMPOP=$P(HMPY,"^",2)
 . S HMPSRCNM=$$UP^XLFSTR($P(HMPY,"^",1))
 . S HMPLAB=""
 . I HMPSRCNM["CLINIC" S HMPVAR="SC("
 . I HMPSRCNM["WARD" S HMPVAR="DIC(42,"
 . I HMPSRCNM["PATIENT" S HMPVAR="DPT("
 . I HMPSRCNM["PCMM TEAM" S HMPVAR="SCTM(404.51,"
 . I HMPSRCNM["OE/RR" S HMPVAR="OR(100.21,"
 . I HMPSRCNM["HMP ROSTER" S HMPVAR="HMPROSTR("
 . I HMPSRCNM["SPECIALTY" S HMPVAR="DIC(45.7,"
 . I HMPSRCNM["PROVIDER" S HMPVAR="VA(200,"
 . I HMPSRCNM["PXRM" S HMPVAR="PXRM(810.4,"
 . S FDA(1,800001.21,"+1,"_HMPRID_",",.01)=HMPZ
 . S FDA(1,800001.21,"+1,"_HMPRID_",",.02)=HMPSRCID_";"_HMPVAR
 . S FDA(1,800001.21,"+1,"_HMPRID_",",.03)=$S(HMPOP="UNION":0,HMPOP="INTERSECTION":1,1:2)
 . I HMPSRCNM="PXRM" S FDA(1,800001.21,"+1,"_HMPRID_",",.06)="UPDATE TEST HMP ROSTER"
 . D UPDATE^DIE("","FDA(1)")
 ;D GET^HMPROS6(HMPRID)
 S FILTER("domain")="roster",FILTER("id")=HMPRID
 D GET^HMPEF(.HMP,.FILTER)
 S RESULT=$$COMPARE(.BEFORE,.AFTER)
 I RESULT=1 D POSTX^HMPEVNT("roster",HMPRID) ;if RESULT is 1 means roster has changed
 Q
 ;
ADDROS ;
 N DIC,DLAYGO,X,Y
 S DIC="^HMPROSTR(",DIC(0)="LQ",DLAYGO=800001.2,X=HMPRNAME D ^DIC S HMPRID=+Y
 Q
 ;
DELROS(HMP,HMPIEN) ;
 S HDUZ(0)=DUZ(0),DUZ(0)="@",DIK="^HMPROSTR(",DA=HMPIEN,DIDEL=1 D ^DIK S DUZ(0)=HDUZ(0),HMP="Roster Deleted!"
 K HDUZ,DIK,DIDEL
 Q
 ;
COMPARE(OLD,NEW) ;
 N HMPII,DIFF
 S HMPII=0 F  S HMPII=$O(OLD(HMPII)) Q:HMPII'>0  D
 . I '$D(NEW(HMPII)) S NEW(HMPII)=""
 . E  K NEW(HMPII)
 S DIFF=$S($O(NEW(0))'>0:0,1:1)
 Q DIFF
 ;
VALIDATE() ;Will verify HMPARRAY entries are all valid
 N I,OUT,OK
 S I="",OK=0,OUT=0
 F  S I=$O(HMPARRAY(I)) Q:I=""  D  Q:OUT
 . I $L(HMPARRAY(I),"^")'=5&($L(HMPARRAY(I),"^")'=3) S @HMP@(1)="Parameter format invalid: "_HMPARRAY(I) S OK=0,OUT=1 Q
 . I $L(HMPARRAY(I),"^")=3 D  Q:OUT
 . . I $P(HMPARRAY(I),"^",2)="UNION"!($P(HMPARRAY(I),"^",2)="INTERSECTION")!($P(HMPARRAY(I),"^",2)="DIFFERENCE") S OK=1,OUT=0
 . . E  S OK=0,OUT=1,@HMP@(1)="Parameter format invalid: "_HMPARRAY(I) Q
 . . I $P(HMPARRAY(I),"^",3)>0 S OK=1,OUT=0
 . . E  S OK=0,OUT=1,@HMP@(1)="Parameter format invalid: "_HMPARRAY(I) Q
 Q OK
 ;
BEFORE ;SAVE EXISTING ROSTER PATIENTS
 Q:$O(^HMPROSTR(HMPRID,4,0))'>0
 S I=0 F  S I=$O(^HMPROSTR(HMPRID,4,I)) Q:I'>0  S DFN=$P(^HMPROSTR(HMPRID,4,I,0),"^"),BEFORE(DFN)=""
 Q
 ;
TEST ;TEMPORARY
 S HMPARRAY(0)="AAA TEST^^aaaa test^^1088"
 S HMPARRAY(1)="Patient^UNION^100846"
 S HMPARRAY(2)="Patient^UNION^100847"
 D UPDATE(.HMP,.HMPARRAY)
 Q
TEST0 ;
 S BEFORE(1)="",BEFORE(5)="",BEFORE(8)="",AFTER(1)="",AFTER(5)="",AFTER(8)=""
 S RESULT=$$COMPARE(.BEFORE,.AFTER)
 W "RESULT IS: ",RESULT
 Q
 ;
TEST1 ;
 S BEFORE(1)="",BEFORE(5)="",BEFORE(8)="",AFTER(5)="",AFTER(8)=""
 S RESULT=$$COMPARE(.BEFORE,.AFTER)
 W "RESULT IS: ",RESULT
 Q
 ;
