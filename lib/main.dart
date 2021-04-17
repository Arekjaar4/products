import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/product.dart';

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Productos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Productos'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  var context;
  var products = [];


  void _addProduct() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          var name;
          var price;
          var description;
          var image;
          List availableColours = [];
          var firstTimeName = true;
          var firstTimePrice = true;
          var firstTimeDescription = true;
          var firstTimeImage = true;
          return AlertDialog(
            content: Stack(
              children: <Widget>[
                Container(
                    width: 300,
                    child: SingleChildScrollView(
                        child: Form(
                      autovalidateMode: AutovalidateMode.always,
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: TextFormField(
                                decoration: const InputDecoration(
                                  hintText: 'Nombre del producto',
                                  labelText: 'Nombre',
                                ),
                                onChanged: (String value) {
                                  firstTimeName = false;
                                },
                                onSaved: (String value) {
                                  name = value;
                                },
                                validator: (String value) {
                                  return (value.isEmpty && !firstTimeName)
                                      ? 'Campo obligatorio'
                                      : null;
                                }),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: TextFormField(
                                decoration: const InputDecoration(
                                  hintText: 'Precio del producto',
                                  labelText: 'Precio',
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[.,0-9]')),
                                ],
                                onChanged: (String value) {
                                  firstTimePrice = false;
                                },
                                onSaved: (String value) {
                                  price =
                                      double.parse(value).toStringAsFixed(2);
                                },
                                validator: (String value) {
                                  return (value.isEmpty && !firstTimePrice)
                                      ? 'Campo obligatorio'
                                      : null;
                                }),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: TextFormField(
                                decoration: const InputDecoration(
                                  hintText: 'Descripción del producto',
                                  labelText: 'Descripción',
                                ),
                                onChanged: (String value) {
                                  firstTimeDescription = false;
                                },
                                onSaved: (String value) {
                                  description = value;
                                },
                                validator: (String value) {
                                  return (value.isEmpty &&
                                          !firstTimeDescription)
                                      ? 'Campo obligatorio'
                                      : null;
                                }),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: TextFormField(
                                decoration: const InputDecoration(
                                  hintText: 'Url de la imagen del producto',
                                  labelText: 'Imagen',
                                ),
                                onChanged: (String value) {
                                  firstTimeImage = false;
                                },
                                onSaved: (String value) {
                                  image = value;
                                  availableColours.add(image);
                                },
                                validator: (String value) {
                                  return firstTimeImage
                                      ? null
                                      : value.isEmpty
                                          ? 'Campo obligatorio'
                                          : !value.startsWith('http')
                                              ? 'Introduce una url valida'
                                              : null;
                                }),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: TextFormField(
                                decoration: const InputDecoration(
                                  hintText: 'Url de la imagen del producto',
                                  labelText: 'Color disponible',
                                ),
                                onSaved: (String value) {
                                  availableColours.add(value);
                                },
                                validator: (String value) {
                                  return value.isNotEmpty &&
                                          !value.startsWith('http')
                                      ? 'Introduce una url valida'
                                      : null;
                                }),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              child: Text("Guardar"),
                              onPressed: () {
                                firstTimeName = false;
                                firstTimePrice = false;
                                firstTimeDescription = false;
                                firstTimeImage = false;
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();
                                  setState(() {
                                    products.add(new Product(name, price,
                                        description, image, availableColours));
                                  });
                                  Navigator.of(context).pop();
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    ))),
              ],
            ),
          );
        });
  }

  Widget _buildCards(Product product) {
    var colourAvailableSelected = product.availableColours.isNotEmpty
        ? product.availableColours[0]
        : null;
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Card(
        elevation: 5,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                    child:
                        Center(child: Image.network(colourAvailableSelected))),
                ExpandableNotifier(
                    child: ExpandablePanel(
                  theme: const ExpandableThemeData(
                      tapBodyToCollapse: true,
                      headerAlignment: ExpandablePanelHeaderAlignment.center),
                  header: Text(
                    product.name,
                    softWrap: true,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  expanded: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Colores dsponibles',
                          style: TextStyle(fontSize: 10),
                        ),
                        Row(
                          children: [
                            for (var availableColour
                                in product.availableColours)
                              Flexible(
                                  child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          colourAvailableSelected =
                                              availableColour;
                                        });
                                      },
                                      child: Image.network(
                                        availableColour,
                                        width: 80,
                                      ))),
                          ],
                        )
                      ]),
                )),
                Text(product.description,
                    softWrap: true,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                Text(product.price + '€',
                    softWrap: true,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.red))
              ],
            )),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: OrientationBuilder(builder: (context, or) {
        int cac = (or == Orientation.portrait) ? 2 : 4;
        return GridView.count(
          crossAxisCount: cac,
          childAspectRatio: (1 / 1.5),
          children: List.generate(products.length, (index) {
            return _buildCards(products[index]);
          }),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: _addProduct,
        tooltip: 'Añadir elemento',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
