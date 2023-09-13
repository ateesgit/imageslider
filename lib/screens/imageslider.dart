import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class ImageSliderFirebase extends StatefulWidget {
  const ImageSliderFirebase({super.key});

  @override
  State<ImageSliderFirebase> createState() => _ImageSliderFirebaseState();
}

class _ImageSliderFirebaseState extends State<ImageSliderFirebase> {
    late Stream<QuerySnapshot> imageStream;
    int currentSliderIndex = 0 ;
    CarouselController carouselController =CarouselController();

  
  @override
  void initState() {
    // TODO: implement initState
  
    super.initState();
    var firebase = FirebaseFirestore.instance;
    imageStream = firebase.collection('donor').snapshots();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
           SizedBox(
            height: 500,
            width: double.infinity,
            child: StreamBuilder<QuerySnapshot>(
              stream: imageStream,
              builder:(_,snapshot){
                if(snapshot.hasData && snapshot.data!.docs.length >1){
                  
                  return CarouselSlider.builder(
                    carouselController: carouselController,
                    itemCount:snapshot.data!.docs.length , 
                    itemBuilder: (_,index,___){
                      DocumentSnapshot sliderImage = snapshot.data!.docs[index];
                      return Column(
                        children: [
                          Image.network(sliderImage['image'],
                          // fit: BoxFit.contain,
                          height: 100,
                          width: double.infinity,
                          ),
                              Text(sliderImage['name']),
                        ],
                      );
                    }, 
                    options: CarouselOptions(
                      autoPlay: true,
                      enlargeCenterPage: true,
                      onPageChanged: (index, _) {
                        setState(() {
                          currentSliderIndex = index;
                        });
                      },
                    )
                  );
                }else{
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              } ),
           ),
           const SizedBox(height: 20,),
           Text("Current Slide Index $currentSliderIndex",style: TextStyle(fontSize: 20),)
        ],
      ),
    );
  }
}