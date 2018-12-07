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
        //int n [] = {3,13,30};

        //camera1 >85%
        //camera2 >83%
        //camera3 > 90%
        //camera4 > 90%

        String cameraHeat1 = cameraRepository.getOne(1).getCoordinate();
        String cameraHeat2 = cameraRepository.getOne(2).getCoordinate();
        String cameraHeat3 = cameraRepository.getOne(3).getCoordinate();
        String cameraHeat4 = cameraRepository.getOne(4).getCoordinate();

        List<DensityEntity> densitiesOfCamera1 = densityRepository.getDensityEntitiesWithinMinutesByCamera_Id(1, 10);
        List<DensityEntity> densitiesOfCamera2 = densityRepository.getDensityEntitiesWithinMinutesByCamera_Id(2, 10);
        List<DensityEntity> densitiesOfCamera3 = densityRepository.getDensityEntitiesWithinMinutesByCamera_Id(3, 10);
        List<DensityEntity> densitiesOfCamera4 = densityRepository.getDensityEntitiesWithinMinutesByCamera_Id(4, 10);

        if(densitiesOfCamera1.size() >= 1){
            DensityEntity densityEntity1 = densitiesOfCamera1.get(0);
            DensityEntity densityEntity2 = densitiesOfCamera2.get(0);
            DensityEntity densityEntity3 = densitiesOfCamera3.get(0);
            DensityEntity densityEntity4 = densitiesOfCamera4.get(0);

            result.put(cameraHeat1, getLevelOfTraffic(densityEntity1.getDensity(), 1));
            result.put(cameraHeat2, getLevelOfTraffic(densityEntity2.getDensity(), 2));
            result.put(cameraHeat3, getLevelOfTraffic(densityEntity3.getDensity(), 3));
            result.put(cameraHeat4, getLevelOfTraffic(densityEntity4.getDensity(), 4));
            System.out.println("Hai ba trung: " + densityEntity1.getDensity() + "\n" +
                    "Phan Van Tri: " + densityEntity2.getDensity() + "\n" +
                    "Tran Hung Dao: " + densityEntity3.getDensity() + "\n" +
                    "Tran Quoc Hoang " + densityEntity4.getDensity() + "\n");
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

    public int getLevelOfTraffic(int density, int camera_id){
        int level = 0;
        if(camera_id == 1){
            if(density >= 85){
                level = 30;
            }
            else if(density < 85 && density >= 65){
                level = 13;
            }
            else if(density < 65 && density >= 40){
                level = 3;
            }
        }

        if(camera_id == 2){
            if(density >= 83){
                level = 30;
            }
            else if(density < 83 && density >= 50){
                level = 13;
            }
            else if(density < 50 && density >= 35){
                level = 3;
            }
        }

        if(camera_id == 3){
            if(density >= 70){
                level = 30;
            }
            else if(density < 70 && density >= 50){
                level = 13;
            }
            else if(density < 50 && density >= 35){
                level = 3;
            }
        }

        if(camera_id == 4){
            if(density >= 70){
                level = 30;
            }
            else if(density < 70 && density >= 40){
                level = 13;
            }
            else if(density < 40 && density >= 25){
                level = 3;
            }
        }
        return level;
    }
}
