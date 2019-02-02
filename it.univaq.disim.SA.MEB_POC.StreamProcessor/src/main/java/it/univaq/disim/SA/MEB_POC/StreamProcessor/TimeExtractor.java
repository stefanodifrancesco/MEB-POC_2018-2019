package it.univaq.disim.SA.MEB_POC.StreamProcessor;

import java.io.StringReader;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.xml.bind.JAXB;

import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.apache.kafka.streams.processor.TimestampExtractor;

import it.univaq.disim.SA.MEB_POC.StreamProcessor.Models.InhibitEvent;

public class TimeExtractor implements TimestampExtractor {

	@Override
	public long extract(ConsumerRecord<Object, Object> record, long previousTimestamp) {
		
	    String message = (String) record.value();
	    if (message != null) {
	    	InhibitEvent event = JAXB.unmarshal(new StringReader(message), InhibitEvent.class);
	    	String timestampString = event.getInserted().getEvent_datetime();
	    	SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS");
	        Date parsedDate = null;
			try {
				parsedDate = dateFormat.parse(timestampString);
			} catch (ParseException e) {
				e.printStackTrace();
			}
			if (parsedDate != null) {
				Timestamp timestamp = new Timestamp(parsedDate.getTime());
				return timestamp.getTime();
			} else {
				return System.currentTimeMillis();
			}
	        
	    }
	    else {
	      // Kafka allows `null` as message value.  How to handle such message values
	      // depends on your use case.  In this example, we decide to fallback to
	      // wall-clock time (= processing-time).
	      return System.currentTimeMillis();
	    }
	}
}
