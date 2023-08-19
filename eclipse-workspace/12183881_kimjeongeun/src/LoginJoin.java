import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import javax.swing.*;
import javax.swing.border.Border;

class Join extends JFrame {
	
	public Join() {
		
		this.setTitle("Join");
		this.setBackground(Color.pink);
		this.setLayout(new BorderLayout());

		JPanel loginComponents = new JPanel();
		loginComponents.setLayout(new GridLayout(4, 2));
		loginComponents.setBackground(Color.pink);
		
		JLabel id = new JLabel("ID", JLabel.CENTER);
		JTextField idTextField = new JTextField(10);

		JLabel passWord = new JLabel("PASSWORD", JLabel.CENTER);
		JPasswordField passWordTextField = new JPasswordField(10);
		
		JLabel name = new JLabel("Name", JLabel.CENTER);
		JTextField nameTextField = new JTextField(10);
				
		JButton joinButton = new JButton("Join");
		JButton cancelButton = new JButton("Cancel");

		joinButton.setLayout(new FlowLayout(FlowLayout.LEFT));
		cancelButton.setLayout(new FlowLayout(FlowLayout.RIGHT));
		
		loginComponents.add(name);
		loginComponents.add(nameTextField);
		loginComponents.add(id);
		loginComponents.add(idTextField);
		loginComponents.add(passWord);
		loginComponents.add(passWordTextField);
	
		loginComponents.add(joinButton);
		loginComponents.add(cancelButton);

		Panel components = new Panel();
		components.setBackground(Color.pink);
		components.add(loginComponents, BorderLayout.CENTER);
		this.add(components,BorderLayout.CENTER);
				
		setResizable(false);
		this.setSize(300, 180); 
		this.setLocationRelativeTo(null);
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setVisible(true);

		joinButton.addActionListener(e -> {
				if (joinButton == e.getSource()) {
		               try {
		            	   String getID = idTextField.getText();
		   					String getPassword = new String(passWordTextField.getPassword());
		   					String getName = nameTextField.getText();
		                   if (getID.isEmpty() || getPassword.isEmpty() || getName.isEmpty()) { // checking if the note is empty or not
		                       JOptionPane.showMessageDialog(this, "Not found!\nThe nil value is included.\n", "INFO", JOptionPane.INFORMATION_MESSAGE); // showing the message
		                   } else {

		       				JOptionPane.showMessageDialog
		       					(null, "name : "+getName+", ID : "+getID+
		       					", password: "+getPassword);
			   				ToDoFrame frame = new ToDoFrame(); 
		       				dispose();
		                   }
		               } catch (Exception ex) {
		                   JOptionPane.showMessageDialog(this, "error", "EXIT", JOptionPane.ERROR_MESSAGE);
		               }
		           }

		});
		
		
		cancelButton.addActionListener(new ActionListener() {
			
			@Override
			public void actionPerformed(ActionEvent e) {
				
				new Login();
				dispose();
				
			}
		});
	}
}

class Login extends JFrame {
	
	public Login() {
		this.setTitle("Login");
		this.setBackground(Color.pink);
		this.setLayout(new BorderLayout());

		JPanel loginComponents = new JPanel();
		loginComponents.setLayout(new GridLayout(3, 2));
		loginComponents.setBackground(Color.pink);
		
		JLabel id = new JLabel("ID", JLabel.CENTER);
		JTextField idTextField = new JTextField(10);

		JLabel passWord = new JLabel("PASSWORD", JLabel.CENTER);
		JPasswordField passWordTextField = new JPasswordField(10);
				
		JButton loginButton = new JButton("Login");
		JButton joinButton = new JButton("Join");

		loginButton.setLayout(new FlowLayout(FlowLayout.LEFT));
		joinButton.setLayout(new FlowLayout(FlowLayout.RIGHT));
		
		loginComponents.add(id);
		loginComponents.add(idTextField);
		loginComponents.add(passWord);
		loginComponents.add(passWord); 
		loginComponents.add(passWordTextField);
	
		loginComponents.add(loginButton);
		loginComponents.add(joinButton);

		Panel components = new Panel();
		components.setBackground(Color.pink);
		components.add(loginComponents, BorderLayout.CENTER);
		
		this.add(components,BorderLayout.CENTER);
				
		setResizable(false);
		this.setSize(300, 150); 
		this.setLocationRelativeTo(null);
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setVisible(true);
		
	
		loginButton.addActionListener(e -> {
			if (loginButton == e.getSource()) {
	               try {
	            	   String getID = idTextField.getText();
	   					String getPassword = new String(passWordTextField.getPassword());
	                   if (getID.isEmpty() || getPassword.isEmpty() ) { // checking if the note is empty or not
	                       JOptionPane.showMessageDialog(this, "Not found!\nThe nil value is included.\n", "INFO", JOptionPane.INFORMATION_MESSAGE); // showing the message
	                   } else {

	                	   JOptionPane.showMessageDialog
	   					(null, "ID: "+getID+", Password: "+getPassword);
	   				ToDoFrame frame = new ToDoFrame(); 
	   				dispose();
	                   }
	               } catch (Exception ex) {
	                   JOptionPane.showMessageDialog(this, "error", "EXIT", JOptionPane.ERROR_MESSAGE);
	               }
	           }
		});
		
		joinButton.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {		
				new Join();
				dispose();  			
			}
		});
	}
}

public class LoginJoin {

	public static void main(String[] args) {
		new Login();
	}
}

