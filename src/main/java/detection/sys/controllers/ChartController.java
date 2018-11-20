package detection.sys.controllers;

import detection.sys.entities.DensityEntity;
import detection.sys.repositories.CameraRepository;
import detection.sys.repositories.DensityRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.*;

@Controller
public class ChartController {
    @Autowired
    private CameraRepository cameraRepository;

    @Autowired
    private DensityRepository densityRepository;

    @RequestMapping("/chart")
    public String showChart(Model model){
        List<DensityEntity> densityEntities= densityRepository.getDensityEntitiesByCamera_Id(1);
        List<Map<Date, Integer>> list = new ArrayList<>();

        for(DensityEntity den: densityEntities){
            Map<Date, Integer> map = new TreeMap<>();
            map.put(den.getDateTime(), den.getDensity());
            list.add(map);
        }
        model.addAttribute("dataPoints",list);
        return "chart";
    }

}
//https://canvasjs.com/spring-mvc-charts/dynamic-live-line-chart/
