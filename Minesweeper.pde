import de.bezier.guido.*;
private int NUM_ROWS = 5;
private int NUM_COLS = 5;
private MSButton[][] buttons;  //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList<MSButton>(); //ArrayList of just the minesweeper buttons that are mined
private boolean lost = false;

void setup ()
{
  frameRate(60);
  size(400, 400);
  textAlign(CENTER, CENTER);

  // make the manager
  Interactive.make( this );
  buttons = new MSButton[NUM_ROWS][NUM_COLS];
  for (int i = 0; i < NUM_ROWS; i++) {
    for (int j = 0; j < NUM_COLS; j++) {
      buttons[i][j] = new MSButton(i, j);
    }
  }

  for (int i = 0; i < 1/*(NUM_ROWS*NUM_COLS/3)*/; i++) {
    setMines();
  }
}
public void setMines()
{
  int row = (int)(Math.random()*NUM_ROWS);
  int col = (int)(Math.random()*NUM_COLS);
  if (!mines.contains(buttons[row][col])) {
    mines.add(buttons[row][col]);
  } else {
    setMines();
  }
}

public void draw ()
{
  background( 0 );
  if (isWon() == true) {
    displayWinningMessage();
    //bool = true;
  }
}
public boolean isWon()
{
  for (int i = 0; i < NUM_ROWS; i++) {
    for (int j = 0; j < NUM_COLS; j++) {
      if (!mines.contains(buttons[i][j]) && (buttons[i][j].isFlagged() || buttons[i][j].clicked == false)) {
        return false;
      }
    }
  }
  for (int i = 0; i < mines.size(); i++) {
    if (mines.get(i).flagged == false) {
      return false;
    }
  }
  return true;
}
public void displayLosingMessage()
{
  lost = true;
  for (int i = 0; i < NUM_ROWS; i++) {
    for (int j = 0; j < NUM_COLS; j++) {
      if (mines.contains(buttons[i][j])) {
        buttons[i][j].clicked = true;
      }
    }
  }
}
public void displayWinningMessage()
{
  frameRate(10);
}
public boolean isValid(int r, int c)
{
  if (r < NUM_ROWS && r >= 0 && c < NUM_COLS && c >=0)
    return true;
  else
    return false;
}
public int countMines(int row, int col)
{
  int numMines = 0;
  for (int i = row-1; i <= row+1; i++) {
    for (int j = col-1; j <= col+1; j++) {
      if (isValid(i, j) && !(i==row && j==col) && mines.contains(buttons[i][j])) {
        numMines++;
      }
    }
  }
  return numMines;
}
public class MSButton
{
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean clicked, flagged;
  private String myLabel;

  public MSButton ( int row, int col )
  {
    width = 400/NUM_COLS;
    height = 400/NUM_ROWS;
    myRow = row;
    myCol = col; 
    x = myCol*width;
    y = myRow*height;
    myLabel = "";
    flagged = clicked = false;
    Interactive.add( this ); // register it with the manager
  }

  // called by manager
  public void mousePressed () 
  {
    if (flagged == false){
      clicked = true;
    }
    if (mouseButton == RIGHT) {
      flagged = !flagged;
      if (flagged == false) {
        clicked = false;
      }
    } else if (mines.contains(this)) {
      displayLosingMessage();
    } else if (countMines(myRow, myCol)>0) {
      setLabel(countMines(myRow, myCol));
    } else {
      for (int i = myRow-1; i <= myRow+1; i++) {
        for (int j = myCol-1; j <= myCol+1; j++) {
          if (isValid(i, j) && !(i==myRow && j==myCol) && !buttons[i][j].clicked) {
            buttons[i][j].mousePressed();
          }
        }
      }
    }
  }
  public void draw () 
  {    
    if (isWon() == false && lost == false) {
      if (flagged)
        fill(24, 141, 219);
      else if ( clicked && mines.contains(this) ) 
        fill(255, 0, 0);
      else if (clicked)
        fill( 200 );
      else 
      fill( 100 );

      rect(x, y, width, height);
      fill(0);
      textAlign(CENTER, CENTER);
      textSize(24);
      text(myLabel, x+width/2, y+height/2);
    } else if (lost == true) {
      if (flagged)
        fill(24, 141, 219);
      else if ( clicked && mines.contains(this) ) 
        fill(255, 0, 0);
      else if (clicked)
        fill( 100 );
      else 
      fill( 50 );

      rect(x, y, width, height);
      fill(0);
      textAlign(CENTER, CENTER);
      textSize(24);
      text(myLabel, x+width/2, y+height/2);
      
      fill(0);
      rect(25, 140, 350, 75);
      textAlign(CENTER);
      fill(255, 0, 0);
      textSize(64);
      text("You Lose!", 200, 200);
    } else {
      if (flagged)
        fill(24, 141, 219);
      else if ( clicked && mines.contains(this) ) 
        fill(255, 0, 0);
      else if (clicked)
        fill((int)(Math.random()*255), 0, (int)(Math.random()*150));
      else 
      fill( 75 );

      rect(x, y, width, height);
      fill(0);
      textAlign(CENTER, CENTER);
      textSize(24);
      text(myLabel, x+width/2, y+height/2);

      fill(0);
      rect(25, 140, 350, 75);
      textAlign(CENTER);
      fill(219, 190, 24);
      textSize(64);
      text("You Win!", 200, 200);
    }
  }
  public void setLabel(String newLabel)
  {
    myLabel = newLabel;
  }
  public void setLabel(int newLabel)
  {
    myLabel = ""+ newLabel;
  }
  public boolean isFlagged()
  {
    return flagged;
  }
}
