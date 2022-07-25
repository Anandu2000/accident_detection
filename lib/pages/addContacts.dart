import 'package:flutter/material.dart';

class AddContacts extends StatefulWidget {
  const AddContacts({Key? key}) : super(key: key);

  @override
  State<AddContacts> createState() => _AddContactsState();
}

class _AddContactsState extends State<AddContacts> {

  final List<String> names = <String>['Sujith', 'Amal', 'Rithul', 'Anandu'];
  final List<String> mobNumber = <String>[ '9495995852', '987642310', '6545557487', '9494945647'];

  TextEditingController nameController = TextEditingController();
  TextEditingController mobNumberController = TextEditingController();
  bool _validatem = false;
  bool _validaten = false;

  void addItemToList(){
    setState(() {
      names.insert(0,nameController.text);
      mobNumber.insert(0, mobNumberController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.contacts),
        title: Text('Add Contacts'),
        backgroundColor: Colors.grey,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: names.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      height: 50,
                      margin: EdgeInsets.all(2),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.all(Radius.circular(10)),
                          color: index % 2 == 0 ? Colors.grey.shade200: Colors.grey.shade500,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(width: 15,),
                            Text('${names[index]}',
                              style: TextStyle(fontSize: 18),
                            ),
                            Text('${mobNumber[index]}',
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(width: 2,)
                          ],
                        ),
                      ),
                    );
                  }
              )
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 5),
            child: TextField(
              controller: nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Contact Name',
                errorText: _validaten ? 'Value cannot be empty' : null,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 5, 20, 20),
            child: TextField(
              controller: mobNumberController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Mobile Number',
                errorText: _validatem ? 'Value cannot be empty' : null,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.add),
            color: Colors.grey,
            hoverColor: Colors.grey,
            onPressed: () {
              mobNumberController.text.isEmpty ? _validatem = false : _validatem = true;
              nameController.text.isEmpty ? _validaten = false : _validaten = true;
              if(_validatem && _validaten) {
                addItemToList();
                nameController.clear();
                mobNumberController.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}
