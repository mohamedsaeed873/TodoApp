import 'package:flutter/material.dart';
import 'package:todo/shared/cubit/cubit.dart';

class NewTask extends StatelessWidget {
Map? model;
   NewTask({super.key , required this.model});

  @override
  Widget build(BuildContext context ) {
    return  Dismissible(
      key: Key(model!['id'].toString()),
      onDismissed: (directhon){

        AppCubit.get(context).deleteDataBase(id: model!['id']);
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
      children: [
        CircleAvatar(
          maxRadius: 35,
           child: Text('${model!['time']}', style: TextStyle(fontSize:15 , color: Colors.white),),
           backgroundColor: Colors.blue,
        ),
        SizedBox(width: 20,),
       Expanded(
         child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${model!['title']}" , style: TextStyle(fontSize: 20 ,),),
            SizedBox(height: 5,),
            Text("${model!['data']}" , style: TextStyle(fontSize: 15 , color: Colors.grey),),
          ],
         ),
       ),
        SizedBox(width: 20,),
        IconButton(
          onPressed: () {
            AppCubit.get(context).updateDataBase(
              status: 'done',
              id: model!['id'],
            );
          },
          icon: Icon(
            Icons.check_box,
            color: Colors.green,
          ),
        ),
        IconButton(
          onPressed: () {
            AppCubit.get(context).updateDataBase(
              status: 'archive',
              id: model!['id'],
            );
          },
          icon: Icon(
            Icons.archive,
            color: Colors.black38,
          ),
        ),

      ],

          ),
        ),
      ),
    );
  }
}