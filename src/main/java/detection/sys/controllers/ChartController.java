package detection.sys.controllers;

import detection.sys.entities.DensityEntity;
import detection.sys.repositories.CameraRepository;
import detection.sys.repositories.DensityRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
public class ChartController {
    @Autowired
    private CameraRepository cameraRepository;

    @Autowired
    private DensityRepository densityRepository;

    @RequestMapping("/chart")
    public String showChart(){
        List<DensityEntity> denList = densityRepository.getDensityEntitiesByCamera_Id(1);







        return "chart";
    }

}
