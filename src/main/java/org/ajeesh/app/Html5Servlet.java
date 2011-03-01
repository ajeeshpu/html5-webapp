package org.ajeesh.app;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Timer;
import java.util.TimerTask;
import java.util.concurrent.atomic.AtomicInteger;

import javax.servlet.http.HttpServletRequest;

import org.eclipse.jetty.websocket.WebSocket;
import org.eclipse.jetty.websocket.WebSocketServlet;

public class Html5Servlet extends WebSocketServlet {

	private AtomicInteger index = new AtomicInteger();

	private static final List<String> tickers = new ArrayList<String>();
	static{
		tickers.add("ajeesh");
		tickers.add("peeyu");
		tickers.add("kidillan");
		tickers.add("entammo");
	}

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected WebSocket doWebSocketConnect(HttpServletRequest req, String resp) {
		System.out.println("On server");
		return new StockTickerSocket();
	}
	protected String getMyJsonTicker(){
		StringBuilder start=new StringBuilder("{");
		start.append("\"stocks\":[");
		int counter=0;
		for (String aTicker : tickers) {
			counter++;
			
			start.append("{ \"ticker\":\""+aTicker +"\""+","+"\"price\":\""+index.incrementAndGet()+"\" }");
			if(counter<tickers.size()){
				start.append(",");
			}
		}
		start.append("]");
		start.append("}");
		return start.toString();
	}
	public class StockTickerSocket implements WebSocket
	{

		private Outbound outbound;
		Timer timer; 
		public void onConnect(Outbound outbound) {
			this.outbound=outbound;
			timer=new Timer();
		}

		public void onDisconnect() {
			timer.cancel();
		}

		public void onFragment(boolean arg0, byte arg1, byte[] arg2, int arg3,
				int arg4) {
			// TODO Auto-generated method stub
			
		}

		public void onMessage(final byte frame, String data) {
			if(data.indexOf("disconnect")>=0){
				outbound.disconnect();
			}else{
				timer.schedule(new TimerTask() {
						
						@Override
						public void run() {
							try{
								System.out.println("Running task");
								outbound.sendMessage(frame,getMyJsonTicker());
							}
							catch (IOException e) {
								e.printStackTrace();
							}
						}
					}, new Date(),5000);

			}
			
		}

		public void onMessage(byte arg0, byte[] arg1, int arg2, int arg3) {
			// TODO Auto-generated method stub
			
		}
		
	}
	

}
