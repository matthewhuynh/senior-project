package detection.sys.repositories;

import detection.sys.entities.DensityEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface DensityRepository extends JpaRepository<DensityEntity, Integer> {
    public List<DensityEntity> getDensityEntitiesByCamera_Id(int id);
}
