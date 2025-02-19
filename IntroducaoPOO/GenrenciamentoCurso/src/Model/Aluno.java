package Model;

public class Aluno extends Pessoa {
    //atributos(encapsulamento)
    private String matricula;
    private String nota;
    //métodos
    //construtor
    public Aluno(String nome, String cpf, String matricula) {
        super(nome, cpf);
        this.matricula = matricula;
    }
    //getter and setters
    
    public String getMatricula() {
        return matricula;
    }


    public void setMatricula(String matricula) {
        this.matricula = matricula;
    }


    public String getNota() {
        return nota;
    }


    public void setNota(String nota) {
        this.nota = nota;
    }

    
     //soberecriva exibirINformações
     @Override
     public void exibirinformacoes(){
         super.exibirinformacoes();
         System.out.println("Matricula:" +matricula);
         System.out.println("Nota:" +nota);
     }

}
