import javax.swing.*;
import java.awt.*;

class Onboarding extends JFrame {
    JLabel text=new JLabel("DAILY TODO LIST");
    JProgressBar progressBar=new JProgressBar();
    JLabel message=new JLabel();

    Onboarding()
    {	
    	text.setFont(new Font("SansSerif",Font.BOLD,20)); 
        text.setBounds(0,150,400,30);
        text.setForeground(Color.gray);
        text.setHorizontalAlignment(JLabel.CENTER);

        this.add(text);
        this.setSize(400,400);
        this.getContentPane().setLayout(null); 
        this.setUndecorated(true); 
        this.setLocationRelativeTo(null); 
        this.getContentPane().setBackground(Color.pink); 
        this.setVisible(true);
        progressBar();
        startProgressBar();
    }

    
    public void progressBar(){
        progressBar.setBounds(100,280,200,50); 
    	progressBar.setValue(0); 
        progressBar.setForeground(Color.gray);
        progressBar.setOpaque(false);
        progressBar.setBorderPainted(true);
        this.add(progressBar);
    }
    
    public void startProgressBar(){
    	        int i=0;
    	        while(i<=100)
    	        {
    	        	progressBar.setValue(i);
    	            try{
    	                Thread.sleep(50);  
    	                if (i==100) {
    	                	this.dispose();
    	                }
    	            }catch(Exception e){
    	                e.printStackTrace();
    	            }
    	            i++;
    	        }
    	    }
    
    public static void main(String[] args) {
		new Onboarding();  
	}
}