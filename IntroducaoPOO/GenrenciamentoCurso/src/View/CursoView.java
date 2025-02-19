package View;

import java.nio.channels.Pipe.SourceChannel;
import java.util.Scanner;

import Controller.CursosController;
import Model.Aluno;
import Model.Professor;

public class CursoView {
    // atributos
    Professor jp = new Professor("Joao Pereira", "123.456.789.10", 15000.00);
    CursosController cursoJava = new CursosController("Programação Java", jp);
    private int operacao;
    private boolean continuar = true;
    Scanner sr = new Scanner(System.in);

    // metodos
    public void menu() {
        while (continuar) {
            System.out.println("==Gerenciamento Curso==");
            System.out.println("|1. Cadastrar aluno");
            System.out.println("|2. Informações do Curso");
            System.out.println("|3. Lançar nota dos alunos");
            System.out.println("|4. Status da turma");
            System.out.println("|5. Sair...");
            System.out.println("|6. == Escolha opçao desejada");
            operacao = sr.nextInt();
            switch (operacao) {
                case 1:
                   Aluno aluno = cadastrarAluno();
                    cursoJava.adicionarAluno(aluno);
                    break;
                case 2:
                  cursoJava.exibirInformacoesCurso();
                  break;
                case 3:
                break;
               case 4:
               break;
               case 5:
                System.out.println("Saindo...");
                continuar = false;
                break;       
                default:
                System.out.println("Infrome uma Opção Valid");
                    break;
            }
        }
    }

    private Aluno cadastrarAluno() {
        System.out.println("Digite o Nome do aluno");
        String nome = sr.next();
        System.out.println("Informe o CPF do aluno");
        String cpf = sr.next();
        System.out.println("Informw a matricula do aluno");
        String matricula = sr.next();
        return new Aluno(nome, cpf, matricula);

    }
}