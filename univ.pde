//odabir primjera:
//1 - jezik 0*
//2 - rijeci oblika 0^n1^n
//3 - parni palindromi
int primjer=3;

//odabir ulazne rijeci
String w = "1001";

//kod TS koji odlucuje jezik 0*
String inp1 = "0|1|10|||0|1|||0|1| ||| |||10|0|10|0|1||10| |1| |1||10|1|0|1|1|||0|||1|||10";
//jezik 0^n1^n
String inp2 = "0|1|10|11|100|101|||0|1|||0|1| ||| |||10|0|11| |1||10| |1| |1||11|0|11|0|1||11|1|11|1|1||11| |100| |0||100|1|101| |0||101|0|101|0|0||101|1|101|1|0||101| |10| |1|||0|||1|||10";
//jezik parnih palindroma
String inp3 = "0|1|10|11|100|101|110|111|||0|1|||0|1| ||| |||10|0|11| |1||10|1|110| |1||10| |1| |1||11|0|11|0|1||11|1|11|1|1||11| |100| |0||100|0|101| |0||110|0|110|0|1||110|1|110|1|1||110| |111| |0||111|1|101| |0||101|0|101|0|0||101|1|101|1|0||101| |10| |1|||0|||1|||10";

//pomocne varijable

boolean lastPressed=false; //prati jesmo li pokrenuli/pauzirali racunanje
int korak=1; //prati tijek programa
String[] empty={}; //uvijek samo prazan niz stringova
int sep=0, t=0; //broje separatore pri inicijalizaciji traka
String[] input=empty; //ulaz <T,w>

//TS i njegove trake
machine stroj;
tape inputTape,first,second,third;


void setup() {
  
  //postavljanje ulaza ovisno o odabranom primjeru
  String inp;
  switch (primjer){
    case 1: inp=inp1; break;
    case 2: inp=inp2; break;
    default: inp=inp3;
  }
  inp += "||||" + w;
  input = inp.split("");
  
  //inicijalizacija traka
  inputTape=new tape(30,input);
  first=new tape(150,empty);
  second=new tape(270,empty);
  third=new tape(390,empty);
  
  tape[] tapes={inputTape,first,second,third};
  stroj=new machine(tapes);
  
  //crtanje pocetne pozicije TS
  stroj.start();
  
  //izgled ekrana
  size(1000, 720);
  background(200);
  
}

//draw funkcija se neprestano ponovno izvrsava,
//brzinom zadanom sa frameRate=
//broj slika po sekundi (default=60)
void draw() {
  //iznova crta stroj
  stroj.update();
  
  if(lastPressed){
    kod(); //program iz dokaza
  }
  
}

//fja koja se poziva kod pritiska tipke
void keyPressed(){
  if(keyCode==ENTER){
    lastPressed=true;
    //pokretanje programa u kod()
  }
  if(keyCode==TAB){
    lastPressed=false;
    //pauziranje programa
  }
  //promjena brzine programa
  if(key=='1') frameRate(1);
  if(key=='2') frameRate(15);
  if(key=='3') frameRate(30);
  if(key=='4') frameRate(60);
  
  //micanje po prvoj pomocnoj traci
  //program se pritom pauzira
  if(keyCode==RIGHT){
    lastPressed=false;
    stroj.read(1,first);
  }
  if(keyCode==LEFT){
    lastPressed=false;
    stroj.read(-1,first);
  }
}

//program koji prati pseudokod u seminaru
//varijabla korak sluzi kako bi se promjene
//traka u kodu postupno crtale na ekran,
//umjesto sve odjednom/prebrzo
void kod(){
    //provjera je li u zavrsnom stanju
    if(stroj.state=="t"){
      println("Prihvaćam riječ!");      
      textSize(20);      
      textAlign(LEFT);
      text("Prihvaćam riječ!",30,550);
      stroj.returnToStart(first);
      stroj.returnToStart(second);
      lastPressed=false;
    }
    else if(stroj.state=="f"){
      println("Odbijam riječ!");
      textSize(20);
      textAlign(LEFT);
      text("Odbijam riječ!",30,550);
      stroj.returnAllToStart();   
      stroj.returnToStart(first);
      stroj.returnToStart(second);   
      lastPressed=false;
    }
    
  if(korak==1){
    stroj.write("*",1,first);
    stroj.write("*",1,second);
  }
  if(korak==2){
    String r = stroj.read(1,inputTape);
    if(r.equals("|")){
      sep++;
      
      if(sep>=3) t++;
    }
    else{
      sep=0;
    }
    
    if(t<4){
      korak--;
    }
    else if (t==4){
      
    }
    else{
      stroj.write(" ",-1,first);
      stroj.write(" ",-1,first);
      stroj.write("*",-1,first);
      korak=4;
      return;
    }
  }
  if(korak==3){
    String r = stroj.read(1,inputTape);
    if(r.equals("|")){
      sep++;
      
      if(sep==2) r="#";
      
      if(sep>=3) t++;
      }
      else{
        sep=0;
      }
      
      if(t>4){
        korak=2;
        return;
      }
      
      stroj.write(r,1,first);
      return;
  }
  if(korak==4){
    String r = stroj.read(1,inputTape);
    if(r.equals("|")){
      sep++;
      
      if(sep>=3) t++;
    }
    else{
      sep=0;
    }
    
    if(t<7){
      return;
    }
    else if(t==7){
      if(!r.equals("|")) stroj.write(r,1,second);
      return;
    }
    else{
      if(!r.equals("|")) stroj.write(r,1,third);
      if(r.equals(" ")){
        stroj.write("*",1,second);
      }
      else return;
    }
  }
  if(korak==5){
    stroj.returnAllToStart();
    stroj.move(1,first);
    stroj.move(1,second);
  }
  
  if(korak==6){ //stanje CH
    String r = stroj.read(1,second);
    if(r.equals("0")){
      korak=7;
      return;
    }
    else if(r.equals("1")){
      korak=8;
      return;
    }
    else stroj.state="f";
  }
  if(korak==7){ //stanje REJ
    String r = stroj.read(2,second);
    if(r=="*"){
      stroj.state="f";
      return;
    }
    else{
      stroj.move(-1,second);
      korak=9;
      return;
    }
  }
  if(korak==8){ //stanje ACC
    String r = stroj.read(2,second);
    if(r=="*"){
      stroj.state="t";
      return;
    }
    else{
      stroj.move(-1,second);
      korak=9;
      return;
    }
  }
  if(korak==9){ //stanje ST
    String r1 = stroj.read(2,first);
    String r2 = stroj.read(2,second);
    
    if(r1.equals(r2) && !r1.equals("*")){
      stroj.move(1,first);
      stroj.move(1,second);
      return;
    }
    else if(r1.equals("|") && r2.equals("*")){
      stroj.move(1,first);
      korak=12;
      return;
    }
    else if(!r1.equals("|") && r2.equals("*")){
      stroj.move(1,first);
      stroj.move(-1,second);
      korak=10;
      return;
    }
    else if(!r1.equals(r2) && !r1.equals("*")){
      stroj.move(1,first);
      korak=10;
      return;
    }
    else{
      stroj.state="f";
      return;
    }
  }
  if(korak==10){ //stanje NM1
    String r = stroj.read(2,second);
    
    if(r.equals("*")){
      stroj.move(1,first);
      korak=11;
      return;
    }
    else{
      stroj.move(1,first);
      stroj.move(-1,second);
      return;
    }
  }
  if(korak==11){ //stanje NM2
    String r = stroj.read(1,first);
    
    if(r.equals("#")){
      stroj.move(1,second);
      korak=9;
      return;
    }
    else if(r.equals("*")){
      stroj.state="f";
      return;
    }
    else{
      return;
    }
  }
  if(korak==12){ //stanje SK
    String r1 = stroj.read(1,first);
    String r3 = stroj.read(2,third);
    
    if(r1.equals(r3)){
      stroj.write(" ",-1,second);
      korak=13;
      return;
    }
    else{
      stroj.move(-1,second);
      korak=10;
      return;
    }
  }
  if(korak==13){ //stanje MB
    String r = stroj.read(2,second);
    
    if(r.equals("*")){
      stroj.move(1,first);
      stroj.move(1,second);
      korak=14;
      return;
    }
    else{
      stroj.write(" ",-1,second);
      return;
    }
  }
  if(korak==14){ //stanje WR
    String r = stroj.read(1,first);
    
    if(r.equals("|")){
      stroj.write("*",2,second);
      korak=15;
      return;
    }
    else{
      stroj.write(r,1,second);
      return;
    }
  }
  if(korak==15){ //stanje MV
    String r = stroj.read(1,first);
    stroj.write(r,2,third);
  }
  if(korak==16){ //stanje NV
    String r = stroj.read(2,first);
    
    if(r.equals("|")){
      stroj.move(1,first);
      return;
    }
    else{
      if(r.equals("1")) stroj.move(1,third);
      else stroj.move(-1,third);
    }
  }
  if(korak==17){ //stanje RPT
    String r1 = stroj.read(2,first);
    String r2 = stroj.read(2,second);
    
    if(!r1.equals("*") && !r1.equals("*")){
      stroj.move(-1,first);
      stroj.move(-1,second);
      return;
    }
    else if(!r1.equals("*") && r2.equals("*")){
      stroj.move(-1,first);
      return;
    }
    else{
      stroj.move(1,first);
      stroj.move(1,second);
      korak=6;
      return;
    }
  }
  korak++;
  return;
}
