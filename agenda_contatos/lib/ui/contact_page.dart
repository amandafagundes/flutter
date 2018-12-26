import 'dart:io';
import 'package:agenda_contatos/helpers/contact_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ContactPage extends StatefulWidget {
  final Contact contact;

  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  Contact _editedContact;
  bool _userEdited = false;
  bool _validateName = true, _validateEmail = true, _validatePhone = true;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.contact == null)
      _editedContact = Contact();
    else {
      _editedContact = Contact.fromMap(widget.contact.toMap());
      _nameController.text = _editedContact.name;
      _emailController.text = _editedContact.email;
      _phoneController.text = _editedContact.phone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_editedContact.name ?? "Novo Contato"),
          backgroundColor: Colors.pinkAccent,
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              GestureDetector(
                child: Container(
                  width: 140.0,
                  height: 140.0,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: _editedContact.img != null
                              ? FileImage(File(_editedContact.img))
                              : AssetImage("images/avatar.png"))),
                ),
                onTap: () {
                  ImagePicker.pickImage(source: ImageSource.gallery)
                      .then((file) {
                    if (file == null) return;
                    setState(() {
                      _editedContact.img = file.path;
                    });
                  });
                },
              ),
              TextField(
                decoration: InputDecoration(
                    labelText: "Nome",
                    errorText: !_validateName ? "Campo obrigatório!" : null),
                onChanged: (text) {
                  _userEdited = true;
                  setState(() {
                    _editedContact.name = text;
                  });
                },
                textInputAction: TextInputAction.next,
                controller: _nameController,
              ),
              TextField(
                decoration: InputDecoration(
                    labelText: "E-mail",
                    errorText: !_validateEmail ? "Campo obrigatório!" : null),
                onChanged: (text) {
                  _userEdited = true;
                  _editedContact.email = text;
                },
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
              ),
              TextField(
                decoration: InputDecoration(
                    labelText: "Telefone",
                    errorText: !_validatePhone ? "Campo obrigatório!" : null),
                onChanged: (text) {
                  _userEdited = true;
                  _editedContact.phone = text;
                },
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.phone,
                controller: _phoneController,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.pinkAccent,
            child: Icon(Icons.save),
            onPressed: () {
              setState(() {
                _nameController.text.isEmpty
                    ? _validateName = false
                    : _validateName = true;
                _emailController.text.isEmpty
                    ? _validateEmail = false
                    : _validateEmail = true;
                _phoneController.text.isEmpty
                    ? _validatePhone = false
                    : _validatePhone = true;
              });
              if (_validateName && _validateEmail && _validatePhone)
                Navigator.pop(context, _editedContact);
            }),
      ),
    );
  }

  Future<bool> _requestPop() {
    if (_userEdited) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Descartar alterações?"),
              content: Text("Se sair sem salvar as alterações serão perdidas"),
              actions: <Widget>[
                FlatButton(
                  child: Text("Sim"),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text("Não"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            );
          });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
