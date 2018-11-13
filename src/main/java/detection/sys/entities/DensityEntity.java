package detection.sys.entities;

import javax.persistence.*;
import java.util.Date;
import java.util.Optional;

@Entity
@Table(name = "density")
public class DensityEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    private Date dateTime;
    private int density;

    @ManyToOne(cascade=CascadeType.ALL)
    @JoinColumn(name = "camera_id")
    private CameraEntity camera;

    public DensityEntity(Date dateTime, int density, CameraEntity camera) {
        this.dateTime = dateTime;
        this.density = density;
        this.camera = camera;
    }

    public DensityEntity() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Date getDateTime() {
        return dateTime;
    }

    public void setDateTime(Date dateTime) {
        this.dateTime = dateTime;
    }

    public int getDensity() {
        return density;
    }

    public void setDensity(int density) {
        this.density = density;
    }
}
