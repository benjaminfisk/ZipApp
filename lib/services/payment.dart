import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:stripe_payment/stripe_payment.dart';
//import 'package:stripe_sdk/stripe_sdk.dart' as stripe1;
//import 'package:stripe_sdk/stripe_sdk_ui.dart' as Stripe2;

class Payment extends StatefulWidget {
  const Payment({super.key});

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  //late PaymentMethod? _paymentMethod;
  late String _error;
  //late PaymentIntentResult? _paymentIntent;
  List<String> ok = [];
  //Source _source;
  late String _customerID;
  late String _setupSecret;
  ScrollController _controller = ScrollController();
  var customerData = Map();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  //var paymentMethodList;
  @override
  initState() {
    super.initState();

    // StripePayment.setOptions(StripeOptions(
    //     publishableKey: "pk_test_Cn8XIP0a25tKPaf80s04Lo1m00dQhI8R0u"));
    // //   paymentMethodList = [];
    _getPaymentMethods();
  }

  void setError(dynamic error) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(error.toString())));
    setState(() {
      _error = error.toString();
    });
  }

  // Future<void> _getCustomer() async {
  //   print("i have been called");
  //   var firebaseUser = auth.FirebaseAuth.instance.currentUser;
  //   FirebaseFirestore.instance
  //       .collection('stripe_customers')
  //       .doc(firebaseUser?.uid)
  //       .get()
  //       .then((DocumentSnapshot documentSnapshot) {
  //     if (documentSnapshot.exists) {
  //       _customerID = documentSnapshot.data()['customer_id'];
  //       _setupSecret = documentSnapshot.data()['setup_secret'];
  //       customerData = documentSnapshot.data();
  //       if (kDebugMode) {
  //         print("hello");
  //       }
  //       //customerData.forEach((k, v) => print('${k}: ${v}'));
  //     } else {
  //       if (kDebugMode) {
  //         print('Customer does not exist');
  //       }
  //     }
  //   });
  // }

  // Future<void> _triggerCloudFunctionPaymentIntent(data) async {
  //   var firebaseUser = await auth.FirebaseAuth.instance.currentUser;
  //   FirebaseFirestore.instance
  //       .collection("stripe_customers")
  //       .doc(firebaseUser.uid)
  //       .collection('payments')
  //       .add(data);
  // }

//Add Payment method to user
  void _setPaymentMethodID(paymentmethod) async {
    var firebaseUser = auth.FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection("stripe_customers")
        .doc(firebaseUser?.uid)
        .collection('payment_methods')
        .add({"id": paymentmethod.id});
  }

//Functionality that deletes the Payment Method
  Future<void> deletePaymentMethod(paymentListID) {
    var firebaseUser = auth.FirebaseAuth.instance.currentUser;
    CollectionReference paymentsMethods = FirebaseFirestore.instance
        .collection('stripe_customers')
        .doc(firebaseUser?.uid)
        .collection('payment_methods');
    return paymentsMethods
        .doc(paymentListID)
        .delete()
        .then((value) => "Payment Method Succesfully Deleted")
        .catchError((error) => "Failed to delete Payment Method");
  }

  //This function will return a Query snapshot of payment method cards
  Stream<QuerySnapshot> _getPaymentMethods() {
    var firebaseUser = auth.FirebaseAuth.instance.currentUser;
    CollectionReference paymentsMethods = FirebaseFirestore.instance
        .collection('stripe_customers')
        .doc(firebaseUser?.uid)
        .collection('payment_methods');
    print("list of payment methods:");
    print(paymentsMethods.snapshots());
    return paymentsMethods.snapshots();
  }

  /*Future<void> createPaymentMethod() async {
    StripePayment.setStripeAccount(null);
    //tax = ((totalCost * taxPercent) * 100).ceil() / 100;
    //amount = ((totalCost + tip + tax) * 100).toInt();
    //print('amount in pence/cent which will be charged = $amount');
    //step 1: add card
    PaymentMethod paymentMethod = PaymentMethod();
    paymentMethod = await StripePayment.paymentRequestWithCardForm(
      CardFormPaymentRequest(),
    ).then((PaymentMethod paymentMethod) {
      return paymentMethod;
    }).catchError((e) {
      print('Errore Card: ${e.toString()}');
    });
    paymentMethod != null
        ? processPaymentAsDirectCharge(paymentMethod)
        : showDialog(
            context: context,
            builder: (BuildContext context) => ShowDialogToDismiss(
                title: 'Error',
                content:
                    'It is not possible to pay with this card. Please try again with a different card',
                buttonText: 'CLOSE'));
} */
  //Dialog that makes sure that User wants to Delete this payment method
  //if User clicks yes, then this method calls the _deletePaymentMethod() method
  Future<void> _showDeleteAlertDialog(paymentListID) async {
    return showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text("Delete?"),
          content: const Text("Are you sure?"),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: const Text("Yes"),
              onPressed: () {
                try {
                  deletePaymentMethod(paymentListID);
                  showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) {
                      return CupertinoAlertDialog(
                        title: const Text('Succesfully Deleted'),
                        actions: <Widget>[
                          CupertinoDialogAction(
                            child: const Text('Ok'),
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                } catch (error) {
                  showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) {
                      return CupertinoAlertDialog(
                        title: const Text('Error Occured'),
                        actions: <Widget>[
                          CupertinoDialogAction(
                            child: const Text('Ok'),
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  //Dialog if the Payment Method was added succesfully
  Future<void> _addPaymentMethodDialog() async {
    return showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text("Payment Added Successfully!"),
          actions: <Widget>[
            CupertinoDialogAction(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[800],
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(
          'Payment Methods',
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              setState(() {
                // _paymentIntent = null;
                // _paymentMethod = null;
              });
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: ListView(
        controller: _controller,
        padding: EdgeInsets.zero,
        children: <Widget>[
          //Gets Payment Methods
          Card(
            child: ExpansionTile(
              leading: const Icon(Icons.view_headline),
              title: const Text("Payment Methods"),
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: _getPaymentMethods(),
                  builder: (context, snapshot) {
                    /* Timer(Duration(seconds: 2), () {
                      print("Yeah, this line is printed after 2 seconds");
                    });*/
                    /*if (snapshot.hasError) {
                      return CircularProgressIndicator();
                    }*/
                    if (snapshot.hasData) {
                      debugPrint("build widget: ${snapshot.data}");
                      List<QueryDocumentSnapshot> paymentList =
                          snapshot.data!.docs;
                      return DataTable(
                        columnSpacing: 50,
                        columns: const <DataColumn>[
                          DataColumn(
                            label: Text(
                              'Brand',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Last4',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Ending',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                          //Column for trash icon
                          DataColumn(
                            label: Text(""),
                          ),
                        ],
                        rows: List<DataRow>.generate(
                          paymentList.length,
                          (index) => DataRow(
                              /*onSelectChanged: (bool selected) {
                                if (selected) {
                                  log.add('row-selected: ${itemRow.index}');
                                }
                              },*/
                              cells: [
                                DataCell(
                                    Text(paymentList[index]["card"]["brand"]),
                                    onTap: () {
                                  print(
                                      "TESTING ID: ${paymentList[index]['id']})");
                                  //ONLY FOR PAYMENT ONLY //MUST DELETE THIS***************
                                  Navigator.pop(
                                      context, paymentList[index]['id']);
                                }),
                                DataCell(
                                    Text(paymentList[index]["card"]["last4"]),
                                    onTap: () {
                                  //ONLY FOR PAYMNET ONLY! MUST DELETE THIS******************
                                  Navigator.pop(
                                      context, paymentList[index]['id']);
                                }),
                                DataCell(
                                    //(var number = 5);
                                    Text(
                                        '${paymentList[index]["card"]["exp_month"]}/${paymentList[index]["card"]["exp_year"]}'),
                                    onTap: () {
                                  Navigator.pop(context,
                                      paymentList[index]['card']['id']);
                                }),
                                DataCell(
                                  const Icon(Icons.delete_outline),
                                  onTap: () async {
                                    print("TEST: ${paymentList[index].id}");
                                    await _showDeleteAlertDialog(
                                        paymentList[index].id);
                                  },
                                )
                              ]),
                        ),
                      );
                    } else {
                      // We can show the loading view until the data comes back.
                      debugPrint('build loading widget');
                      return const CircularProgressIndicator();
                    }
                  },
                ),
              ],
            ),
          ),
          const Card(
            child: ListTile(
              leading: Icon(Icons.add_circle_outline),
              title: Text("Add new credit/debit card"),
              // onTap: () {
              //   StripePayment.paymentRequestWithCardForm(
              //           CardFormPaymentRequest())
              //       .then((paymentMethod) {
              //     ScaffoldMessenger.of(context).showSnackBar(
              //         SnackBar(content: Text('Received ${paymentMethod.id}')));
              //     setState(() {
              //       //_getCustomer();
              //       _paymentMethod = paymentMethod;
              //       _setPaymentMethodID(_paymentMethod);
              //       _addPaymentMethodDialog();
              //     });
              //   }).catchError(setError);
              //   //_addPaymentMethodDialog();
              // },
            ),
          ),
          /* Divider(),
          Text('Customer data method:'),
          Text(
            JsonEncoder.withIndent('  ')
                .convert(_paymentMethod?.toJson() ?? {}),
            style: TextStyle(fontFamily: "Monospace"),
          ),*/
        ],
      ),
    );
  }
}

/* Expanded(
                      child: SizedBox(
                        height: 400.0,
                        child: ListView.builder(
                          // leading: Icon(Icons.view_headline),
                          itemCount: paymentList.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                  '${paymentList[index]["brand"]} ending in ${paymentList[index]["last4"]} \t\t Ending on ${paymentList[index]["monthAndYear"]}'),
                            );
                          },
                        ),
                      ),
                    );*/
/*FutureBuilder(
                future: _getPaymentMethods(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    debugPrint("build widget: ${snapshot.data}");
                    var paymentList = snapshot.data;
                    print("PaymentList: $paymentList");
                    print(
                        'TEST: ${paymentList[0]["brand"]} ending in ${paymentList[0]["last4"]} \t\t\t\t Ending on ${paymentList[0]["monthAndYear"]}');
                    return ExpansionTile(
                        leading: Icon(Icons.credit_card),
                        title: Text("Credit cards"),
                        children: new List.generate(
                            snapshot.data.length,
                            (index) => new Card(
                                    //title: Text(
                                    //  '${paymentList[index]["brand"]} ending in ${paymentList[index]["last4"]} \t\t Ending on ${paymentList[index]["monthAndYear"]}'),
                                    child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    ListTile(
                                      title: Text(
                                          '${paymentList[index]["brand"]} ending in ${paymentList[index]["last4"]} \t\t Ending on ${paymentList[index]["monthAndYear"]}'),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        IconButton(
                                          icon: Icon(Icons.delete_outline),
                                          onPressed: () {
                                            _scaffoldKey.currentState
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                                        'This will delete ${paymentList[index]}')));
                                          },
                                          //icon: Icon(Icons.delete_outline),
                                        )
                                      ],
                                    ),
                                  ],
                                ))));
                  } else {
                    // We can show the loading view until the data comes back.
                    debugPrint('build loading widget');
                    return CircularProgressIndicator();
                  }
                },
              ),*/

/*  FutureBuilder(
            future: _getPaymentMethods(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                debugPrint("build widget: ${snapshot.data}");
                return ExpansionTile(
                    // leading: Icon(Icons.view_headline),
                    title: Text("Existing cards"),
                    children: new List.generate(
                        snapshot.data.length,
                        (index) => new ListTile(
                              title: Text(
                                  '${snapshot.data[index]["brand"]} ending in ${snapshot.data[index]["last4"]} \t\t Ending on ${snapshot.data[index]["monthAndYear"]}'),
                            )));
              } else {
                // We can show the loading view until the data comes back.
                debugPrint('build loading widget');
                return 
              }
            },
          ),*/
//)),*/
// ignore: await_only_futures
/*var paymentMethodList = [];
    var firebaseUser = await auth.FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection('stripe_customers')
        .doc(firebaseUser.uid)
        .collection('payment_methods')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        var paymentMethod = doc.data();
        bool check = paymentMethod["type"] == "card";
        List emptyList = [];
        if (!check) {
          //do nothing
          print("oh no: $paymentMethod");
          return emptyList;
        } else {
          print("i got here324: $paymentMethod");
          var map = new Map();
          var last4 = paymentMethod["card"]["last4"];
          print("ads: $last4");
          var brand = paymentMethod["card"]["brand"];
          print("watch out: $brand");
          // var type =
          var monthAndYear =
              "${paymentMethod["card"]["exp_month"]}/${paymentMethod["card"]["exp_year"]}";
          map["last4"] = last4;
          map["brand"] = brand;
          map["monthAndYear"] = monthAndYear;
          paymentMethodList.add(map);
        }
      });
    });
    return paymentMethodList;*/

//POtential GetPaymethod methods screen
/*
                      return ExpansionTile(
                        leading: Icon(Icons.credit_card),
                        title: Text("Credit cards"),
                        children:
                            snapshot.data.docs.map((DocumentSnapshot document) {
                          bool check = document.data()["type"] == "card";
                          if (!check) {
                            //do nothing
                            return SizedBox.shrink();
                          } else {
                            print(
                                'TEST: ${document.data()["card"]["brand"]} ending in ${document.data()["card"]["last4"]} \t\t Ending on ${document.data()["card"]["exp_month"]}/${document.data()["card"]["exp_year"]}');
                            return new Card(
                                child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  title: Text(
                                      '${document.data()["card"]["brand"]} ending in ${document.data()["card"]["last4"]} \t\t Ending on ${document.data()["card"]["exp_month"]}/${document.data()["card"]["exp_year"]}'),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    IconButton(
                                      icon: Icon(Icons.delete_outline),
                                      onPressed: () {
                                        _scaffoldKey.currentState.showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    'This will delete ${document.data()["card"]["last4"]}')));
                                      },
                                    )
                                  ],
                                ),
                              ],
                            ));
                          }
                        }).toList(),
                      );*/
