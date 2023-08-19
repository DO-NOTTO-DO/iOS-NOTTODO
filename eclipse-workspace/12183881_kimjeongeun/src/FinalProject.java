import java.awt.*;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.util.ArrayList;

import javax.swing.*;
import javax.swing.border.Border;
import javax.swing.border.LineBorder;

class Detail extends JFrame {
	JTextArea datailText;

	Detail() {
		this.setSize(400,400);
		datailText = new JTextArea();
		datailText.setBounds(90,70,200,50);
		datailText.setBorder(BorderFactory.createLineBorder(Color.BLACK, 3));
	    datailText.setForeground(Color.DARK_GRAY);
	    this.add(datailText);
	    this.setLocationRelativeTo(null);
	    this.setVisible(true);
	}
}

class Todo extends JPanel {
	
    JLabel index;
    JTextField todoTitle;
    JButton todoDetailButton;
    JButton finishedButton, checkButton;
    Panel panel;
	DetailToDo detailTodo;

    private boolean checked = false;

    Todo() {
        this.setPreferredSize(new Dimension(150, 50));
        this.setBackground(Color.pink); 
        this.setLayout(new BorderLayout()); 
        this.setBorder(new LineBorder(Color.BLACK, 1));

        index = new JLabel(""); 
        index.setPreferredSize(new Dimension(20, 20)); 
        index.setHorizontalAlignment(JLabel.CENTER);

        todoTitle = new JTextField("write todo list");
        todoTitle.setBorder(BorderFactory.createEmptyBorder()); 
        todoTitle.setBackground(Color.pink); 

        panel = new Panel(new BorderLayout());
        panel.setBackground(Color.pink);
        finishedButton = new JButton("FINISHED");
        finishedButton.setPreferredSize(new Dimension(65, 20));
        finishedButton.setBorder(BorderFactory.createEmptyBorder());
        finishedButton.setFocusPainted(false);
        
        todoDetailButton = new JButton("DETAIL");
        todoDetailButton.setPreferredSize(new Dimension(50, 20));
        todoDetailButton.setBorder(BorderFactory.createEmptyBorder());
        todoDetailButton.setFocusPainted(false);
        
        checkButton = new JButton("CHECK");
        checkButton.setPreferredSize(new Dimension(50, 20));
        checkButton.setBorder(BorderFactory.createEmptyBorder());
        checkButton.setFocusPainted(false);
       	
        checkButton.addActionListener(e -> {
           if (checkButton == e.getSource()) {
               try {
                   String checkAllTodo = detailTodo.detailToDo.get(detailTodo.detailToDo.size() - 1); 
                   if (checkAllTodo.isEmpty()) { 
                       JOptionPane.showMessageDialog(this, "No note found!", "INFO", JOptionPane.INFORMATION_MESSAGE); // showing the message
                   } else {
                	   Detail detail = new Detail();
                	   detail.datailText.setText(checkAllTodo);
                   }
               } catch (Exception ex) {
                   JOptionPane.showMessageDialog(this, "error", "EXIT", JOptionPane.ERROR_MESSAGE);
               }
           }
       }
       ); 
      
       todoDetailButton.addActionListener(new ActionListener() {
		@Override
		public void actionPerformed(ActionEvent e) {
			DetailToDo datail = new DetailToDo(); 	
		}  	   
       });
        
       	this.add(index, BorderLayout.WEST); 
        this.add(panel, BorderLayout.EAST);
        this.add(todoTitle, BorderLayout.CENTER);

        panel.add(finishedButton, BorderLayout.EAST);
        panel.add(todoDetailButton,BorderLayout.WEST);
        panel.add(checkButton,BorderLayout.CENTER);

    }
 
    public void stateToggle() {
        if (!checked){
        	checked = true; 
        	this.setBackground(Color.lightGray);
            todoTitle.setBackground(Color.lightGray);
            panel.setBackground(Color.lightGray);
            revalidate();
        }else {
        	checked = false;
        	this.setBackground(Color.pink);
            todoTitle.setBackground(Color.pink);
            panel.setBackground(Color.pink);
            revalidate();
       }
    }
}

class TodoList extends JPanel {
	public int number;
	
    TodoList() {
        GridLayout layout = new GridLayout(5, 1,0 ,0);
        layout.setVgap(2); 
        this.setLayout(layout); 
        this.setPreferredSize(new Dimension(380, 300));
        this.setBackground(Color.PINK);
    }

    public void addIndex() {
        Component[] listItems = this.getComponents();

        for (int i = 0; i < listItems.length; i++) {
            if (listItems[i] instanceof Todo) {
                ((Todo) listItems[i]).index.setText(i + 1 + "");
                this.revalidate();            
                this.number = i+1;            
            }          
        }
    }
}

class ToDoFrame extends JFrame {
	
	JButton add;
    TodoList list;
	Panel title;
	Panel body;
    Panel header;

    ToDoFrame() {
    	this.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE); 
        
        Border emptyBorder = BorderFactory.createEmptyBorder();

    	// title
        title = new Panel();
    	title.setPreferredSize(new Dimension(400, 30));
        JLabel titleText = new JLabel("DAILY TODO LIST"); 
        titleText.setPreferredSize(new Dimension(200, 30));
        titleText.setFont(new Font("SansSerif",Font.BOLD,18)); 
        titleText.setHorizontalAlignment(JLabel.CENTER); 
        title.add(titleText); 
      
      //  button
        
        add = new JButton("ADD"); 
        add.setBorder(emptyBorder); 
        add.setFont(new Font("SansSerif",Font.PLAIN,15)); 
        add.setVerticalAlignment(JButton.CENTER); 

        list = new TodoList();
        header = new Panel();
        header.setSize(400, 80);
        header.setLayout(new GridLayout(2,1));
        body = new Panel();
        body.setSize(400, 300);
        body.add(list);

        header.add(title);
        header.add(add);
        
        this.setSize(400, 400); 
        this.setVisible(true); 
        
        this.add(header, BorderLayout.NORTH);
        this.add(body, BorderLayout.CENTER); 
        this.setBackground(Color.pink);
	    this.setLocationRelativeTo(null);

        add.addMouseListener(new MouseAdapter() {
        	@Override
            public void mousePressed(MouseEvent e) {
                Todo todo = new Todo();
                list.add(todo); 
                list.addIndex(); 

                todo.finishedButton.addMouseListener(new MouseAdapter() {
                    @Override
                    public void mousePressed(MouseEvent e) {
                        todo.stateToggle(); 
                    }
                });
            }

        });
    }
}

public class FinalProject {
	public static void main(String[] args) {
		Onboarding onboarding =  new Onboarding();  
       try { 
    	 Login login = new Login();
       } catch (Exception ex) { 
    	   ex.printStackTrace(); 
       }
	}
	@interface override {

	}

 }

