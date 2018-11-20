package detection.sys.controllers;

import detection.sys.entities.CameraEntity;
import detection.sys.entities.DensityEntity;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import detection.sys.repositories.CameraRepository;
import detection.sys.repositories.DensityRepository;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;


@Controller
public class HomeController {
    @Autowired
    private CameraRepository cameraRepository;

    @Autowired
    private DensityRepository densityRepository;

    @RequestMapping("/")
    public String index(){
        return "index";
    }


    @PostMapping(value = "/getState")
    @ResponseBody
    public String getState(@RequestBody Map<String, Integer> data) throws ParseException {
        //System.out.println(data.toString());
//        Map<String, Integer> cameraMap1 = new TreeMap<>();
//        Map<String, Integer> cameraMap2 = new TreeMap<>();
//        Map<String, Integer> cameraMap3 = new TreeMap<>();
//        Map<String, Integer> cameraMap4 = new TreeMap<>();
        CameraEntity camera1 = cameraRepository.findById(1).get();
        CameraEntity camera2 = cameraRepository.findById(2).get();
        CameraEntity camera3 = cameraRepository.findById(3).get();
        CameraEntity camera4 = cameraRepository.findById(4).get();


//        CameraEntity camera1 = new CameraEntity("Ly Tu Trong _ Hai Ba Trung", "10.779195870344578, 106.70220611460695");
//        CameraEntity camera2 = new CameraEntity("Pham Van Dong _ Phan Van Tri", "10.820844541194742, 106.69392781160514");
//        CameraEntity camera3 = new CameraEntity("Nguyen Van Cu _ Tran Hung Dao", "10.75648002498592, 106.68511004962215");//(10.756429958448201, 106.68526025332699)
//        CameraEntity camera4 = new CameraEntity("Tran Quoc Hoang _ Hoang Van Thu", "10.800814959119283, 106.66173560388575");
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
//
        for(String key: data.keySet()){
            if(key.contains("camera1")){
                //cameraMap1.put(key, data.get(key));

                String time = key.split("_")[1];

                Date dateTime = dateFormat.parse(time);

                DensityEntity density= new DensityEntity(dateTime, data.get(key), camera1);
                densityRepository.save(density);

            }
            else if(key.contains("camera2")) {
                //cameraMap2.put(key, data.get(key));
                String time = key.split("_")[1];
                Date dateTime = dateFormat.parse(time);

                DensityEntity density= new DensityEntity(dateTime, data.get(key), camera2);
                densityRepository.save(density);
            }
            else if(key.contains("camera3")) {
                //cameraMap3.put(key, data.get(key));
                String time = key.split("_")[1];
                Date dateTime = dateFormat.parse(time);

                DensityEntity density= new DensityEntity(dateTime, data.get(key), camera3);
                densityRepository.save(density);
            }
            else if(key.contains("camera4")) {
                //cameraMap4.put(key, data.get(key));
                String time = key.split("_")[1];
                Date dateTime = dateFormat.parse(time);

                DensityEntity density= new DensityEntity(dateTime, data.get(key), camera4);
                densityRepository.save(density);
            }
        }
        return null;
    }
}
