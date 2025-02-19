package Model;

public class Professor extends Pessoa {
    private double salario;

    public Professor(String nome, String cpf, double salario) {
        super(nome, cpf);
        this.salario = salario;
    }

    // getters and setters

    public double getSalrio() {
        return salario;
    }

    public void setSalrio(double salrio) {
        this.salario = salrio;
    }

    @Override
    public void exibirinformacoes() {
        super.exibirinformacoes();
        System.out.println("Salário :R$" + salario);

    }

}
