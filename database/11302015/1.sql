<<<<<<< HEAD
ALTER TABLE `bids` ADD `date_submitted` DATETIME NOT NULL ;
=======

DROP TABLE IF EXISTS report_templates;
CREATE TABLE IF NOT EXISTS report_templates (
  id bigint(20) NOT NULL AUTO_INCREMENT,
  report_type varchar(300) NOT NULL,
  details text NOT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
>>>>>>> 574772ae450f0b4fe0209fdd98fe9e4fa7520f95
