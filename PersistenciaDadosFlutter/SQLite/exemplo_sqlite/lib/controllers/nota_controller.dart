import 'package:exemplo_sqlite/models/nota_model.dart';
import 'package:exemplo_sqlite/services/nota_db_helper.dart';

class NotaController {
  static final NotaDbHelper _dbHelper = NotaDbHelper();

  //criar os controller
  Future<int> createNota(Nota nota) async {
    return _dbHelper.insertNota(nota);
  }


//  get

Future<List<Nota>> readNota() async {
  return await _dbHelper.getNotas();
}

 //upadte

 Future<int> updateNota(Nota nota) async{
  return await _dbHelper.updateNota(nota);

 }

//delte

Future<int> delteNota(int id) async{
  return await _dbHelper.deleteNota(id);
}


}
