@radiologyreport_fhir @fhir @vxsync @patient
Feature: F138 Return of Radiology Reports in FHIR format

#This feature item returns Radiology Reports in FHIR format. Also includes cases where no Radiology Reports exist.

@F138_1_radiologyreport_fhir @fhir @10107V395912
Scenario: Client can request Radiology Reports in FHIR format
  Given a patient with "radiology report results" in multiple VistAs
  And a patient with pid "10107V395912" has been synced through the RDK API
  When the client requests radiology report results for the patient "10107V395912" in FHIR format
  Then a successful response is returned
  Then the client receives 88 FHIR "VistA" result(s)
  And the client receives 44 FHIR "panorama" result(s)
  And the FHIR results contain "radiology report results"
      | field                                 | panorama_value                                          |
      | content.extension.url    	            | http://vistacore.us/fhir/extensions/rad#statusName      |
      | content.extension.valueString         | COMPLETE                                                |
      | content.extension.url                 | http://vistacore.us/fhir/extensions/rad#imagingTypeUid  |
      | content.extension.valueString         | urn:va:imaging-Type:GENERAL RADIOLOGY                   |
      | content.extension.url                 | http://vistacore.us/fhir/extensions/rad#hasImages       |
      | content.extension.valueString         | false                                                   |
      | content.extension.url                 | http://vistacore.us/fhir/extensions/rad#providerUid     |
      | content.extension.valueString         | urn:va:user:9E7A:1595                                   |
      | content.extension.url                 | http://vistacore.us/fhir/extensions/rad#providerName    |
      | content.extension.valueString         | PROVIDER,FIFTY                                          |
      | content.extension.url                 | http://vistacore.us/fhir/extensions/rad#locationUid     |
      | content.extension.valueString         | urn:va:location:9E7A:40                                 |
      | content.extension.url                 | http://vistacore.us/fhir/extensions/rad#locationName    |
      | content.extension.valueString         | RADIOLOGY MAIN FLOOR                                |
      | content.text.status                   | generated                                           |
      | content.text.div                      | IS_SET                                              |
      | content.contained._id                 | IS_SET                                              |
      | content.contained.identifier.system   | urn:oid:2.16.840.1.113883.6.233                     |
      | content.contained.identifier.value    | 500                                                 |
      | content.contained.name                | CAMP MASTER                                         |
      | content.name.text                     | ANKLE 2 VIEWS                                       |
      | content.status                        | final                                               |
      | content.issued                        | 1994-06-17T16:12:00                                 |
      | content.subject.reference             | Patient/10107V395912                                |
      | content.performer.reference           | IS_SET                                              |
      | content.identifier.system             | urn:oid:2.16.840.1.113883.6.233                     |
      | content.identifier.value              | urn:va:image:9E7A:253:7059382.8387-1                |
      | content.serviceCategory.coding.code   | RAD                                                 |
      | content.serviceCategory.coding.display| Radiology                                           |
      | content.serviceCategory.coding.system | http://hl7.org/fhir/v2/0074                         |
      | content.serviceCategory.text          | Radiology                                           |
      | content.diagnosticDateTime            | 1994-06-17T16:12:00                                 |
      | content.codedDiagnosis.text           | NORMAL                                              |
    # | content.presentedForm                 | #74:200, #74:300                                    |

#orderName and interpretation mapping data were not available for the above patient.
#so this test is created to test those field mappings.

@F138_2_radiologyreport_fhir @fhir @10146V393772
Scenario: Client can request Radiology Reports in FHIR format
  Given a patient with "radiology report results" in multiple VistAs
  And a patient with pid "10146V393772" has been synced through the RDK API
  When the client requests radiology report results for the patient "10146V393772" in FHIR format
  Then a successful response is returned
  Then the client receives 26 FHIR "VistA" result(s)
  And the client receives 13 FHIR "panorama" result(s)
  And the FHIR results contain "radiology report results"
      | field                                         | panorama_value                              |
      | content.requestDetail.reference               | IS_SET                                      |

@F138_3_radiologyreport_fhir @fhir @10107V395912
Scenario: Client can request Radiology Reports in FHIR format
  Given a patient with "radiology report results" in multiple VistAs
  And a patient with pid "10107V395912" has been synced through the RDK API
  When the client requests radiology report results for the patient "10107V395912" in FHIR format
  Then a successful response is returned
  Then the client receives 88 FHIR "VistA" result(s)
  And the client receives 44 FHIR "kodak" result(s)
  And the FHIR results contain "radiology report results"
      | field                                 | kodak_value                                             |
      | content.extension.url    	            | http://vistacore.us/fhir/extensions/rad#statusName      |
      | content.extension.valueString         | COMPLETE                                                |
      | content.extension.url                 | http://vistacore.us/fhir/extensions/rad#imagingTypeUid  |
      | content.extension.valueString         | urn:va:imaging-Type:GENERAL RADIOLOGY                   |
      | content.extension.url                 | http://vistacore.us/fhir/extensions/rad#hasImages       |
      | content.extension.valueString         | false                                                   |
      | content.extension.url                 | http://vistacore.us/fhir/extensions/rad#providerUid     |
      | content.extension.valueString         | urn:va:user:C877:1595                                   |
      | content.extension.url                 | http://vistacore.us/fhir/extensions/rad#providerName    |
      | content.extension.valueString         | PROVIDER,FIFTY                                          |
      | content.extension.url                 | http://vistacore.us/fhir/extensions/rad#locationUid     |
      | content.extension.valueString         | urn:va:location:C877:40                                 |
      | content.extension.url                 | http://vistacore.us/fhir/extensions/rad#locationName    |
      | content.extension.valueString         | RADIOLOGY MAIN FLOOR                                |
      | content.text.status                   | generated                                           |
      | content.text.div                      | IS_SET                                              |
      | content.contained._id                 | IS_SET                                              |
      | content.contained.identifier.system   | urn:oid:2.16.840.1.113883.6.233                     |
      | content.contained.identifier.value    | 500                                                 |
      | content.contained.name                | CAMP BEE                                      	    |
      | content.name.text                     | ANKLE 2 VIEWS                                       |
      | content.status                        | final                                               |
      | content.issued                        | 1994-06-17T16:12:00                                 |
      | content.subject.reference             | Patient/10107V395912                                |
      | content.performer.reference           | IS_SET                                              |
      | content.identifier.system             | urn:oid:2.16.840.1.113883.6.233                     |
      | content.identifier.value              | urn:va:image:C877:253:7059382.8387-1                |
      | content.serviceCategory.coding.code   | RAD                                                 |
      | content.serviceCategory.coding.display| Radiology                                           |
      | content.serviceCategory.coding.system | http://hl7.org/fhir/v2/0074                         |
      | content.serviceCategory.text          | Radiology                                           |
      | content.diagnosticDateTime            | 1994-06-17T16:12:00                                 |
      | content.codedDiagnosis.text           | NORMAL                                              |
    # | content.presentedForm                 | #74:200, #74:300                                    |

#orderName and interpretation mapping data were not available for the above patient.
#so this test is created to test those field mappings.

@F138_4_radiologyreport_fhir @fhir @10146V393772
Scenario: Client can request Radiology Reports in FHIR format
  Given a patient with "radiology report results" in multiple VistAs
  And a patient with pid "10146V393772" has been synced through the RDK API
  When the client requests radiology report results for the patient "10146V393772" in FHIR format
  Then a successful response is returned
  Then the client receives 26 FHIR "VistA" result(s)
  And the client receives 13 FHIR "kodak" result(s)
  And the FHIR results contain "radiology report results"
      | field                                         | kodak_value                                 |
      | content.requestDetail.reference               | IS_SET                                      |



# following 2 scenarios are checking for another patient for return of radiology results.
# only few fields are checked to validate data integrity.

@F138_5_radiologyreport_fhir @fhir @9E7A1
Scenario: Client can request radiology report results in FHIR format
  Given a patient with "radiology report results" in multiple VistAs
  And a patient with pid "9E7A;1" has been synced through the RDK API
  When the client requests radiology report results for the patient "9E7A;1" in FHIR format
  Then a successful response is returned
  Then the client receives 70 FHIR "VistA" result(s)
  And the client receives 70 FHIR "panorama" result(s)
  And the FHIR results contain "radiology report results"

		    | field											                | value							                          			    |
		    | content.identifier.value						      | CONTAINS urn:va:image:9E7A:1:7039491	          	    |
	      | content.subject.reference             		| Patient/9E7A;1                                        |
       	| content.codedDiagnosis.text           		| NORMAL                                                |
      	| content.name.text                     		| WRIST 2 VIEWS                                         |
      	| content.extension.url						        	| http://vistacore.us/fhir/extensions/rad#caseId        |
      	| content.extension.valueString					    | 37										                                |
       	| content.extension.url                 		| http://vistacore.us/fhir/extensions/rad#hasImages     |
      	| content.extension.valueString         		| false                                                 |
       	| content.contained.identifier.value    		| 500                                                   |
      	| content.contained.name                		| CAMP MASTER                                           |
       	| content.status                        		| final	                                  	            |
        | content.extension.url                 		| http://vistacore.us/fhir/extensions/rad#locationUid   |
      	| content.extension.valueString         		| urn:va:location:9E7A:40                 	            |
        | content.issued                       			| 1996-05-08T11:23:00                                   |
        | content.extension.url                 		| http://vistacore.us/fhir/extensions/rad#providerName  |
      	| content.extension.valueString         		| PROVIDER,FIFTY                                        |
      	| content.extension.url						        	| http://vistacore.us/fhir/extensions/rad#imageLocation |
      	| content.extension.valueString					    | RADIOLOGY MAIN FLOOR					                      	|

@F138_6_radiologyreport_fhir @fhir @C8771
Scenario: Client can request radiology report results in FHIR format
  Given a patient with "radiology report results" in multiple VistAs
  And a patient with pid "C877;1" has been synced through the RDK API
  When the client requests radiology report results for the patient "C877;1" in FHIR format
  Then a successful response is returned
  Then the client receives 70 FHIR "VistA" result(s)
  And the client receives 70 FHIR "kodak" result(s)
  And the FHIR results contain "radiology report results"

		    | field										                	| value										                              |
		    | content.identifier.value					      	| CONTAINS urn:va:image:C877:1:7039491		              |
	      | content.subject.reference             		| Patient/C877;1                                        |
       	| content.codedDiagnosis.text           		| NORMAL                                                |
      	| content.name.text                     		| WRIST 2 VIEWS                                         |
      	| content.extension.url							        | http://vistacore.us/fhir/extensions/rad#caseId        |
      	| content.extension.valueString				    	| 37									                                	|
       	| content.extension.url                 		| http://vistacore.us/fhir/extensions/rad#hasImages     |
      	| content.extension.valueString         		| false                                                 |
       	| content.contained.identifier.value    		| 500                                                   |
       	| content.status                        		| final	                                              	|
        | content.extension.url                 		| http://vistacore.us/fhir/extensions/rad#locationUid   |
      	| content.extension.valueString         		| urn:va:location:C877:40                              	|
        | content.issued                       			| 1996-05-08T11:23:00                                   |
        | content.extension.url                 		| http://vistacore.us/fhir/extensions/rad#providerName  |
      	| content.extension.valueString         		| PROVIDER,FIFTY                                        |
      	| content.extension.url						        	| http://vistacore.us/fhir/extensions/rad#imageLocation |
      	| content.extension.valueString					    | RADIOLOGY MAIN FLOOR					                      	|

# negative test case.

@F138_7_radiologyreport_neg_fhir @fhir @9E7A100184
Scenario: Negative scenario.  Client can request radiology results in FHIR format
  Given a patient with "No radiology report results" in multiple VistAs
  When the client requests radiology report results for the patient "9E7A;100184" in FHIR format
  Then a successful response is returned
  Then corresponding matching FHIR records totaling "0" are displayed

@F138_8_radiologyreport_fhir @fhir @10107V395912 @DE974
Scenario: Client can request Radiology Reports in FHIR format
  Given a patient with "radiology report results" in multiple VistAs
  And a patient with pid "10107V395912" has been synced through the RDK API
  When the client requests "10" radiology report results for the patient "10107V395912" in FHIR format
  Then a successful response is returned
  And the results contain
      | name         | value     |
      | totalResults | 10        |
  When the client requests radiology report results for the patient "10107V395912" in FHIR format
  Then a successful response is returned
  And the results contain
      | name         | value     |
      | totalResults | 89        |
  When the client requests radiology report results for the patient "10107V395912" in FHIR format with no domain param
  Then a successful response is returned
  And the results contain
      | name         | value     |
      | totalResults | 428       |
