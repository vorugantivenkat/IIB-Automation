/***************************************************************************************
 * File name: Error_Handling_Sub_MF_JavaCompute.java
 * Purpose: Generating the exception message and sending the email notification
 * Ver Author 							  Date 		 Description
 * === =================================== ========== ======================
 * 1.1 Vivek pathangay					  06/25/2014 Initial Release
 * 1.2 Upender Kuncham					  07/20/2017 Reformatted/Refactored
 * COPYRIGHT. Eidiko Systems Integrators Pvt Ltd. ALL RIGHTS RESERVED. NO PART OF THIS SOURCE
 * CODE MAY BE REPRODUCED, STORED IN A RETRIEVAL SYSTEM, OR TRANSMITTED, IN ANY
 * FORM OR BY ANY MEANS,ELECTRONIC, MECHANICAL, PHOTOCOPYING, RECORDING
 * 
 * Note:  The following message should be the expected format to this flow.
 * 				<MSG>
 *				 <ExceptionDetails>
 *					  <Description>Exception detailed description</Description>
 *					  <OrgMsg>Actual Message(payload exists at exception time)</OrgMsg>
 *					  <TimeStamp>2017-06-10T15:11:15.075069+05:30</TimeStamp>
 *					  <FlowName>com.oab.credit.outward.DirectCredit_Outward_Main</FlowName>
 *					  <dbQueryCount>8</dbQueryCount>
 *					 </ExceptionDetails>
 *				</MSG>
-----------------------------------------------------------------------------------------*/

package com.eidiko.exception;

import java.util.Properties;


import com.ibm.broker.config.proxy.BrokerProxy;
import com.ibm.broker.config.proxy.ConfigManagerProxyLoggedException;
import com.ibm.broker.config.proxy.ConfigManagerProxyPropertyNotInitializedException;
import com.ibm.broker.config.proxy.ConfigurableService;
import com.ibm.broker.javacompute.MbJavaComputeNode;
import com.ibm.broker.plugin.MbBLOB;
import com.ibm.broker.plugin.MbElement;
import com.ibm.broker.plugin.MbException;
import com.ibm.broker.plugin.MbMessage;
import com.ibm.broker.plugin.MbMessageAssembly;
import com.ibm.broker.plugin.MbOutputTerminal;
import com.ibm.broker.plugin.MbUserException;
		//public class Error_Handling_Sub_MF_JavaCompute1 extends MbJavaComputeNode {
		public class Error_Handling_SUB_MF_JavaCompute extends MbJavaComputeNode {
			/* (non-Javadoc)
			 * @see com.ibm.broker.javacompute.MbJavaComputeNode#evaluate(com.ibm.broker.plugin.MbMessageAssembly)
			 */
			public void evaluate(MbMessageAssembly inAssembly) throws MbException {
				MbOutputTerminal out = getOutputTerminal("out");
				MbOutputTerminal alt = getOutputTerminal("alternate");

				MbMessage inMessage = inAssembly.getMessage();
				MbMessageAssembly outAssembly = null;
				
					// create new message as a copy of the input
					MbMessage outMessage = new MbMessage(inMessage);
				//	String MessageNumber = " ", Description = " ", FlowLabel = " ", FlowName = "";
					
					MbMessage payloadmessage = new MbMessage(inMessage);
					
					MbMessageAssembly payloadAssembly = new MbMessageAssembly(inAssembly, payloadmessage);
					outAssembly = new MbMessageAssembly(inAssembly, outMessage);
					
						

					
					MbElement msgRef = inMessage.getRootElement().getLastChild().getFirstElementByPath("MSG/ExceptionDetails");
					String ExceptionName = msgRef.getFirstElementByPath("ExceptionName").getValueAsString();
					String Description = msgRef.getFirstElementByPath("Description").getValueAsString();
					String currentTime = msgRef.getFirstElementByPath("TimeStamp").getValueAsString();
					String FlowName = msgRef.getFirstElementByPath("FlowName").getValueAsString();
					String FileName = msgRef.getFirstElementByPath("filename").getValueAsString();			
					byte[] origMsg1 = msgRef.getFirstElementByPath("OrgMsg").toBitstream(null, null,null, 0, 1208, 0);
					String origMsg = new String(origMsg1);
			    								
				    //String currentTime = Calendar.getInstance().getTime().toString();
					String errText  = "<html><body><p style=font-size:12px;>***Integration Bus Generated E-mail***</p>"
									+ "<table width= '750' border='2' cellspacing='4' cellpadding='8'>"
									+ "<th colspan='2' bgcolor='#D8D8D8' style='align:CENTER;font-family:arial;font-size:16px;'>INTEGRATION BUS NOTIFICATION</th>"
									+ 	"<tr><td><i><b>FlowName</b></i></td>"
									+ 		"<td width='70%'>" + FlowName + "</td></tr>"
									+	"<tr><td><i><b>FileName</b></i></td>" 
									+ 		"<td>" + FileName + "</td></tr>"
									+	"<tr><td><i><b>ExceptionName</b></i></td>" 
									+ 		"<td>" + ExceptionName + "</td></tr>"
									+ "	<tr bgcolor='#F8F8F8'><td><i><b>DetailedDescription</b></i></td><td>" + Description + "</td></tr>"
									+ "	<tr><td><i><b>TimeStamp</b></i></td><td>" + currentTime + "</td></tr>"
									+ "</table>"
									+ "<br/>"
									+ "</body></html>";
				
					try {
						this.setEmailAddresses(outAssembly, outMessage, errText,origMsg);
					
					    } 
					//catch (ConfigManagerProxyLoggedException | ConfigManagerProxyPropertyNotInitializedException | InterruptedException e) {
						// if this fails we have a problem, a big one, with the broker
						catch (Exception e) {
							throw new MbUserException(null, "", FlowName, FlowName, "", null);
						// we will ignore it and let the Email Output node to use the node values 
					}
					   MbElement root1 = payloadmessage.getRootElement();
					   String ss = inMessage.getRootElement().getLastChild().getName();
				       MbElement payload = inMessage.getRootElement().getLastChild().getLastChild();
				     //  String s  = payload.getValueAsString();
				       byte[] pbytes = new byte[] { (byte)0x20};
				       
				       if ( ss == "BLOB")
				       {
				        pbytes = (byte[]) payload.getValue();
				        root1.getLastChild().delete();
				       }
					   
					   String pbytesStr = new String(pbytes);
                       
					   String errStr = "FlowName           :  " + FlowName      + "\n" + 
							           "FileName      :  " + FileName     + "\n" + 
							           "ExceptionName	    :  " + ExceptionName + "\n"+
							           "DetailedDescription:  " + Description   + "\n" + 
							           "TimeStamp          :  " + currentTime;
					   String payloadAndException = "Payload:\n" + pbytesStr + "\n" + "ExceptionDetails:" + "\n" +  errStr;
					   MbElement mBlob =  root1.createElementAsLastChild(MbBLOB.PARSER_NAME);
					   mBlob.createElementAsLastChild(MbElement.TYPE_NAME_VALUE, "BLOB",payloadAndException.getBytes());
					   payloadmessage.finalizeMessage(MbMessage.FINALIZE_VALIDATE);
					
					out.propagate(payloadAssembly);
					alt.propagate(outAssembly);
				}
			
			   
				private void setEmailAddresses(MbMessageAssembly outAssembly, MbMessage outMessage, String errText,String orgMsg) 
							   throws ConfigManagerProxyLoggedException,
							   		  InterruptedException,
									  ConfigManagerProxyPropertyNotInitializedException,
									  MbException {
				    // User defined properties for email
					BrokerProxy b = BrokerProxy.getLocalInstance();
					while(!b.hasBeenPopulatedByBroker()) {
						// To ensure that the BrokerProxy object has been populated with data 
						// from the broker before we access the configurable service
						Thread.sleep(100);
					}
					ConfigurableService myUDCS = b.getConfigurableService("UserDefined", "OAB_UDS"); 
					Properties props = myUDCS.getProperties();
					String emailToAddresses = props.getProperty("EmailToAddresses");			
					String emailCcAddresses = props.getProperty("EmailCcAddresses");			 
					//String emailBccAddresses = props.getProperty("EmailBccAddresses");			
					String emailFromAddresses = props.getProperty("EmailFromAddresses");		
					//String emailReplyToAddresses = props.getProperty("EmailReplyToAddresses");
					String emailSubjectLine = props.getProperty("EmailSubjectLine");			
					
					myUDCS = b.getConfigurableService("SMTP", "OAB_SMTP_UDS");
					props = myUDCS.getProperties();
					String serverName = props.getProperty("serverName");					
					//String securityIdentity = props.getProperty("securityIdentity");					
					// Prepare the Email overrides

					// Create the EmailOutputHeader parser. This is where we add recipient, sender and subject information.
					MbElement root = outMessage.getRootElement();
					root.getLastChild().delete();
					root.getLastChild().delete();
					MbElement SMTPOutput = root.createElementAsLastChild("EmailOutputHeader");

					// Add recipient information to EmailOutputHeader
					SMTPOutput.createElementAsLastChild(MbElement.TYPE_NAME_VALUE, "To", emailToAddresses);
					SMTPOutput.createElementAsLastChild(MbElement.TYPE_NAME_VALUE, "Cc", emailCcAddresses);
					//SMTPOutput.createElementAsLastChild(MbElement.TYPE_NAME_VALUE, "Bcc", emailBccAddresses);

					// Add sender information to EmailOutputHeader
					SMTPOutput.createElementAsLastChild(MbElement.TYPE_NAME_VALUE, "From", emailFromAddresses);
					//SMTPOutput.createElementAsLastChild(MbElement.TYPE_NAME_VALUE, "Reply-To", emailReplyToAddresses);

					// Add subject information to EmailOutputHeader
					SMTPOutput.createElementAsLastChild(MbElement.TYPE_NAME_VALUE, "Subject", emailSubjectLine);

					// This part is read from the general SMTP configurable service
					MbElement localEnv = outAssembly.getLocalEnvironment().getRootElement();
					 
					// Create Destination.Email. This is where we add SMTP server information
					MbElement Destination = localEnv.createElementAsLastChild(MbElement.TYPE_NAME, "Destination", null);
					MbElement destinationEmail = Destination.createElementAsLastChild(MbElement.TYPE_NAME, "Email", null);
					destinationEmail.createElementAsLastChild(MbElement.TYPE_NAME_VALUE, "SMTPServer", serverName);
					
					
					MbElement mbattch = destinationEmail.createElementAsLastChild(MbElement.TYPE_NAME_VALUE, "Attachment", null);
					mbattch.createElementAsLastChild(MbElement.TYPE_NAME_VALUE, "Content",orgMsg.getBytes());
					mbattch.createElementAsLastChild(MbElement.TYPE_NAME_VALUE, "ContentType","text/plain");
					mbattch.createElementAsLastChild(MbElement.TYPE_NAME_VALUE, "ContentName","payload.xml");
					
					//destinationEmail.createElementAsLastChild(MbElement.TYPE_NAME_VALUE, "SecurityIdentity", securityIdentity);

					// Set last child of root (message body)
					MbElement BLOB = root.createElementAsLastChild(MbBLOB.PARSER_NAME);
					BLOB.createElementAsLastChild(MbElement.TYPE_NAME_VALUE, "BLOB", errText.getBytes());
					
					
				}
	}