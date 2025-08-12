# json_shared_preferences

A new Flutter project.



Shared Preferences (Armazenamento Interno do Aplicativo)
Armazenamento chae -> Valor 
                    "Config"-> "Texto" texto em formato Json

O que é um exto emFormato Json ->
[
    config:{
        "NomeDoUsario" : "nome do usuario",
        "IdadeDoUsario" : 25,
        "TemaEscuro" : "true",
    }
]

dart -> Linguagem de Progframção do Flutter nao lê JSON
     -> converter => ( json.decode => convert Texto:Json em Map:Dart)
                  => ( json.encode => covert Map:Dart em Texto:Json)