import javax.swing.*;
import javax.swing.border.Border;
import java.awt.event.*;
import java.util.ArrayList;
import java.awt.*;

class DetailToDo extends JFrame {
	public static ArrayList<String> detailToDo = new ArrayList<>();
	public static void main(String args[]) {
		new DetailToDo();			
	}
	
	DetailToDo() {
		this.setTitle("Detail Todo");
		
		TodoList list = new TodoList();
		JTextArea datailText;
		JLabel todoTitle;
		JButton clearButton, saveButton;

		datailText = new JTextArea("");
		clearButton = new JButton("CLEAR");
		saveButton = new JButton("SAVE");
		todoTitle = new JLabel("Write Detail ToDo... ");
		todoTitle.setBackground(Color.white);
		todoTitle.setFont(new Font("SansSerif",Font.BOLD,18));
	    Border lineBorder = BorderFactory.createLineBorder(Color.black, 1);
	    Border emptyBorder = BorderFactory.createEmptyBorder(20, 20, 20, 20);
	    datailText.setBorder(BorderFactory.createCompoundBorder(lineBorder, emptyBorder));
		datailText.setLineWrap(true);
		datailText.setWrapStyleWord(true);	

		saveButton.addActionListener(e4 -> {
            if (saveButton == e4.getSource()) {
                String note = datailText.getText();
                if (note.isEmpty()) {
                    JOptionPane.showMessageDialog(this, "Not found!\nThe nil value is included.\n", "ERROR", JOptionPane.ERROR_MESSAGE);
                } else {
                	detailToDo.add(list.number, note);
                    JOptionPane.showMessageDialog(this, "Note added Successfully !");
                    this.setVisible(false); 
                   datailText.setText(null);
                }
            }
        });
		
		clearButton.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				datailText.setText("");
			}
		});
		
		Panel panel = new Panel();
		panel.setSize(new Dimension(400,100));
		panel.setLayout(new FlowLayout());
		panel.add(saveButton);
		panel.add(clearButton);

		this.add(todoTitle, BorderLayout.NORTH);
		this.add(datailText,BorderLayout.CENTER);
		this.add(panel,BorderLayout.SOUTH);
		this.setSize(400,400);
		this.setResizable(false);
		this.setLocationRelativeTo(null);
		this.setVisible(true);
		this.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
	}
}