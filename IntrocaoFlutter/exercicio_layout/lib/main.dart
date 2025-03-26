import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Perfil',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Container para a imagem do perfil
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage('https://preview.redd.it/9j0do51xvkx61.jpg?auto=webp&s=f8aa48247cfac5ea369a17132713060154100aa8'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 16),
            // Nome e Descrição
            Text(
              'Vitor Hott',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              'Futuro Desenvolvedor | Apaixonado por tecnologia',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 16),
            // Linha com ícones de redes sociais
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.facebook),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.discord),
                  onPressed: () {},
                ),
               
              ],
            ),
            SizedBox(height: 16),
            // Três Containers em uma linha
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.work, color: Colors.white),
                      SizedBox(height: 8),
                      Text('Trabalho', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.greenAccent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.location_on, color: Colors.white),
                      SizedBox(height: 8,),
                      Text('Localização', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.orangeAccent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [ 
                      Icon(Icons.favorite, color: Colors.white),  
                      SizedBox(height: 8),  
                      Text('Interesses', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            // Lista de texto
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(Icons.email),
                    title: Text(': vitor@example.com'),
                  ),
                  ListTile(
                    leading: Icon(Icons.phone),
                    title: Text(':(19) 9999-9999'),
                  ),
                  ListTile(
                    leading: Icon(Icons.web),
                    title: Text(': www.ht.dev'),
                  ),
                  ListTile(
                    leading: Icon(Icons.cake),
                    title: Text(': Data de Nascimento: 15/06/2007'),
                  ),
                  ListTile(
                    leading: Icon(Icons.star),
                    title: Text('Hobbies: Programação, Futebol,'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Buscar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
