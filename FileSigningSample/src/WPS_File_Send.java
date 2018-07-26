import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Map;

import javax.jms.BytesMessage;
import javax.jms.Connection;
import javax.jms.JMSException;
import javax.jms.Message;
import javax.jms.MessageConsumer;
import javax.jms.MessageProducer;
import javax.jms.Queue;
import javax.jms.Session;

import org.apache.activemq.ActiveMQConnectionFactory;


public class WPS_File_Send {
	private static final String SEND_FUNCTION = "SEND";
	//private static final String RECEIVE_FUNCTION = "RECEIVE";
	private static final int RECEIVE_TIMEOUT = 10000;

	public static void sendAndReceive(String function,String fileName,String brokerUrl,String queueName,String fileNaming) {
//		String function = "send";
//		String fileName = "C:/Users/bandaru/Desktop/OAB_DESIGN_DOC_V4/FileSigningSample/SampleRegistrationFile.csv";
//		String keyStoreFileName = "C:/IIBWorkspace/MpclearDigSignissue/testDigSign/OAB.jks";
//		String keyStorePassword = "oab";
//		String keyAlias = "oab_ach";
////		String brokerUrl = "tcp://192.168.1.114:61616";
//		String queueName = "mpc.tst1.regfile.outward";

		if (function.equalsIgnoreCase(SEND_FUNCTION))
			try {
				send(fileName,brokerUrl, queueName,fileNaming);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}

	public static void send(String csvFilePath,String brokerUrl, String queueName,String fileNaming)
			throws Exception {
		byte[] csvFileContents = readFile(csvFilePath);
		
		
		Map<String, String> headers = new HashMap<String, String>();
		headers.put("camelFileName",fileNaming);
		sendToQueue(brokerUrl, queueName, csvFileContents, headers);
		
	}

	public static byte[] readFile(String filePath) throws IOException {
		return Files.readAllBytes(Paths.get(filePath));
	}

	public static void sendToQueue(String brokerUrl, String queueName, byte[] messageBytes, Map<String, String> headers) throws JMSException {
		ActiveMQConnectionFactory connectionFactory = new ActiveMQConnectionFactory(brokerUrl);
		Connection connection = connectionFactory.createConnection();
		connection.start();
		Session session = connection.createSession(false, Session.AUTO_ACKNOWLEDGE);
		Queue queue = session.createQueue(queueName);
		MessageProducer producer = session.createProducer(queue);
		BytesMessage message = session.createBytesMessage();
		message.writeBytes(messageBytes);
		for (Map.Entry<String, String> entry : headers.entrySet())
			message.setStringProperty(entry.getKey(), entry.getValue());
		producer.send(message);
		session.close();
		connection.close();
	}

	public static Message listenOnQueue(String brokerUrl, String queueName) throws JMSException {
		ActiveMQConnectionFactory connectionFactory = new ActiveMQConnectionFactory(brokerUrl);
		Connection connection = connectionFactory.createConnection();
		connection.start();
		Session session = connection.createSession(false, Session.AUTO_ACKNOWLEDGE);
		Queue queue = session.createQueue(queueName);
		MessageConsumer consumer = session.createConsumer(queue);
		Message message = consumer.receive(RECEIVE_TIMEOUT);
		consumer.close();
		session.close();
		connection.close();
		return message;
	}
}
