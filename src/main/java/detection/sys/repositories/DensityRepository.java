package detection.sys.repositories;

import detection.sys.entities.DensityEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface DensityRepository extends JpaRepository<DensityEntity, Integer> {
    @Query(value = "select * from density where camera_id = ?1 order by id desc" ,nativeQuery = true)
    public List<DensityEntity> getDensityEntitiesByCamera_Id(int id);

    @Query(value = "SELECT *  FROM density where camera_id = ?1  and date_time > (now() - interval 30 minute) order by id desc" ,nativeQuery = true)
    public List<DensityEntity> getDensityEntitiesWithin30MinutesByCamera_Id(int id);

    @Query(value = "SELECT * FROM density where camera_id = ?1 order by id desc limit 1\n" ,nativeQuery = true)
    public DensityEntity getLastDensityEntitiesByCamera_Id(int id);



}
