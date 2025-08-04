//klasa koja predstavlja Turingov stroj
class machine{
  tape[] tapes; //popis svih traka
  String state; //trenutno stanje
  
  //konstruktor
  machine(tape[] tapes){
    this.tapes=tapes;
  }
  
  //fje koje pozivaju svoj ekvivalent u klasi tape
  //za danu traku, ili za sve njih
  
  void start(){
    for(int i=0;i<tapes.length;i++){
      tapes[i].start();
    }
  }
  
  void input(tape tape){
    tape.input();
  }
  
  void update(){
    for(int i=0;i<tapes.length;i++){
      tapes[i].update();
    }
  }
  
  String read(int dir, tape tape){
    String r=tape.read(dir);
    return r;
  }
  
  String[] readAll(tape tape){
    String r[]=tape.readAll();
    return r;
  }
  
  void write(String c, int dir, tape tape){
    tape.write(c,dir);
  }
  
  void writeAll(String c[], int dir, tape tape){
    tape.writeAll(c,dir);
  }
  
  void move(int dir, tape tape){
    tape.move(dir);
  }
  
  void empty(tape tape){
    tape.empty();
  }
  
  void returnToStart(tape tape){
    tape.returnToStart();
  }
  
  void returnAllToStart(){
    for(int i=0;i<tapes.length;i++){
      tapes[i].returnToStart();
    }
    return;
  }
  
  void goToEnd(tape tape){
    tape.goToEnd();
  }
}

//klasa koja predstavlja jednu traku
class tape{
  //varijable za crtanje trake
  int x=30,y; //koordinate gornjeg lijevog vrha trake
  int h=60; //visina trake
  int tilew=50; //sirina jednog mjesta na traci
  
  int head=0; //pozicija glave
  String[] content={}; //sadrzaj trake do zadnjeg nepraznog mjesta
  
  //konstruktor
  tape(int y, String[] content){
    this.y=y;
    this.content=content;
  }
  
  //fja za crtanje trake na pocetku rada
  void start(){
    head=0;
    update();
  }
  
  //crta traku
  void drawTape(){
    fill(200);
    noStroke();
    //traka
    rect(0,y,width,h+30);
    fill(255);
    stroke(0);
    //mjesta na traci
    for(int i=0;i+x<=width;i+=tilew){
      rect(x+i,y,tilew,h);
    }
  }
  
  //crta bijeli trokut koji predstavlja glavu
  void drawHead(int pos){
    fill(255);
    triangle(x+5+tilew*pos, y+h+20, x+tilew-5+tilew*pos, y+h+20, x+tilew/2+tilew*pos, y+h+5);
    //argumenti za triangle su koordinate tri vrha
  }
  
  //ispisuje sadrzaj na traku
  void input(){
    fill(0);
    textSize(45);
    textAlign(CENTER);
    for(int i=0;i<content.length;i++){
      text(content[i],x+i*tilew+tilew/2,y+h-15);
    }
  }    
  
  //crta sve za traku
  void update(){
    drawTape();
    drawHead(head);
    input();
    return;
  }

  //funkcija za citanje proizvoljnog znaka
  String read(int dir){
      String r;
      //citamo znak na koji pokazuje glava
      if(head>=content.length) r=" ";
      else r=content[head];
      
      //update pozicije glave nakon citanja
      //za dir>=2 ostaje na istom mjestu
      if(dir==1){
        head++;
      }
      else if (dir<=0){
        head--;
        if(head<0) head=0;
      }
      
      //za prikaz trake
      //ako se ode desno od kraja prozora
      if(head>10){
        if(dir==1)
          x=x-tilew;
        else if (dir<=0)
          x=x+tilew;
      }
      else
        x=30;
     
      update();
      return r;
  }

  //cita cijeli sadrzaj trake
  //(do zadnjeg nepraznog znaka)
  String[] readAll(){
     if(head>0){
       returnToStart();
     }
     String[] tempRead={};
     String c;
     for(int i=0;i<content.length;i++){
       c=read(1);
       tempRead=append(tempRead,c);
     }
     return tempRead;
  }
  
  //funkcija za pisanje danog znaka
  void write(String c, int dir){
    //dodajemo prazne znakove, ako je potrebno,
    //izmedju trenutnog sadrzaja i novog znaka
    if(head>=content.length){
       for(int i=content.length;i<=head;i++){
         content=append(content," ");
       }
    }
    //novi znak pisemo na poziciju glave
    content[head]=c;
    
    //update pozicije glave nakon pisanja
      if(dir==1){
        head++;
      }
      else if (dir<=0){
        head--;
        if(head<0) head=0;
      }
      
    //za prikaz trake
    //ako se ode desno od kraja prozora
      if(head>10){
        if(dir==1)
          x=x-tilew;
        else if (dir<=0)
          x=x+tilew;
      }
      else
        x=30;
        
      update();
  }
  
  //mijenja cijeli sadrzaj trake na str
  void writeAll(String[] str, int dir){
    empty();
    for(int i=0;i<str.length;i++){
      write(str[i],dir);
    }
  }
  
  //funkcija za micanje glave u smjeru dir
  void move(int dir){
    
      //update pozicije glave
      //za dir>=2 ostaje na istom mjestu
      if(dir==1){
        head++;
      }
      else if (dir<=0){
        head--;
        if(head<0) head=0;
      }
      
      //za prikaz trake
      //ako se ode desno od kraja prozora
      if(head>10){
        if(dir==1)
          x=x-tilew;
        else if (dir<=0)
          x=x+tilew;
      }
      else
        x=30;
     
      update();
  }
  
  //jednostavne pomocne funkcije
  
  int length(){
    return content.length;
  }
  
  void empty(){
    content=empty;
    update();
  }
  
  void returnToStart(){
    while(head!=0){
      read(-1);
    }
    return;
  }
  
  void goToEnd(){
    while(head<content.length){
      read(1);
    }
    while(head>content.length){
      read(-1);
    }
    return;
  }
}
