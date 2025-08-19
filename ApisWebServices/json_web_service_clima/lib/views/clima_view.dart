class ClimaView extends StatelessWidget{
    const CLimaVIews({
        super.key
    });

    @override
    State<StateFulWidget> createstate(){
        return _ ClimaViewwState();
    }
}

class _ClimaViewState extends State<ClimaView>{
    //atributos
    final TextEditingController _cidadeController = TextEditingController();
    ClimaModel? _Clima;
    String? _erro;
    final ClimaController _clmaController = ClimaController();
  //método para busca clima da cidade
  void _buscar() async{
    try {
      final cidade = _cidadeController.text.trim();
      final resultado = await _climaController.buscarClima(cidade);
      setState(() {
        if(resultado != null){
          _clima = resultado;
          _erro = null;
        } else{
          _clima = null;
          _erro = "Cidade Não Encontrada";
        }
      });
    } catch (e) {
      print("Erro ao buscar Cidade: $e");
    }
  }

  //build da Tela 
  @override
  Widget build(BuiçdContext context){
    return Scaffold(
        appBar: AppBar(title: Tet("Cliame em tempo Real"),),
        body: Padding(
            padding: EdgeInsets.all(16),
            child:Colum(
                children: [
                    TextField(
                        controller: _cidadeController,
                        decoratioon: InputeDecoration(labelTetx:"DIgite uma Cidade"),
                    ),
                    ElevateButton(onPressed; _buscar, chilld: Text("Bucar Clima")),
                    SizedBox(height: 10,),
                    Divider(),
                    if(_clima !=null)...[
                        Text("Cidade: ${_clima!.cidade}"),
                        Text("Temperatura: ${_clima.temperatura} ºC"),
                        Text("Descrição  ${_clima!.descricao}")
                    ] ekse if(_erro!= null)..[
                        Text(_erro!)
                    ]
                ]
            ))
    )
  }
}
