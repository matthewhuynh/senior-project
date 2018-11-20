package detection.sys.repositories;

import detection.sys.entities.CameraEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface CameraRepository extends JpaRepository<CameraEntity, Integer> {
    public CameraEntity getCameraEntitiesByCoordinate(String coor);
}
