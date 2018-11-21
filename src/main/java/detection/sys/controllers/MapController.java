package detection.sys.controllers;

import detection.sys.entities.CameraEntity;
import detection.sys.entities.DensityEntity;
import detection.sys.repositories.CameraRepository;
import detection.sys.repositories.DensityRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Random;

@Controller
public class MapController {

    @Autowired
    private CameraRepository cameraRepository;

    @Autowired
    private DensityRepository densityRepository;

    @PostMapping(value = "/getDensity")
    @ResponseBody
    public HashMap<String, Integer> getDensity(){
        HashMap<String, Integer> result= new HashMap<>();
        Random random = new Random();
        int n [] = {1,2,3};

        String cameraHeat1 = cameraRepository.getOne(1).getCoordinate();
        String cameraHeat2 = cameraRepository.getOne(2).getCoordinate();
        String cameraHeat3 = cameraRepository.getOne(3).getCoordinate();
        String cameraHeat4 = cameraRepository.getOne(4).getCoordinate();

        List<DensityEntity> densitiesOfCamera1 = densityRepository.getDensityEntitiesByCamera_Id(1);
//        List<DensityEntity> densitiesOfCamera2 = densityRepository.getDensityEntitiesByCamera_Id(2);
//        List<DensityEntity> densitiesOfCamera3 = densityRepository.getDensityEntitiesByCamera_Id(3);
//        List<DensityEntity> densitiesOfCamera4 = densityRepository.getDensityEntitiesByCamera_Id(4);

        DensityEntity densityEntity = densitiesOfCamera1.get(0);

        int minute = (int) ((new Date().getTime() - densityEntity.getDateTime().getTime())/1000/60);
        if(minute <5){
            result.put(cameraHeat1, n[random.nextInt(n.length)]);
            result.put(cameraHeat2, n[random.nextInt(n.length)]);
            result.put(cameraHeat3, n[random.nextInt(n.length)]);
            result.put(cameraHeat4, n[random.nextInt(n.length)]);

            System.out.println(result.values().toString());

            return result;
        }
        else {
            return null;
        }
    }

    @GetMapping(value = "/getInfo")
    @ResponseBody
    public String getInfo(@RequestParam(name = "latlng") String latlng){
        HashMap<String, String> result= new HashMap<>();
        CameraEntity cameraEntity = cameraRepository.getCameraEntitiesByCoordinate(latlng);
        System.out.println(cameraEntity.getName());
        return cameraEntity.getName();
    }

}
