require 'package'

class Hplip < Package
  description 'Print, Scan and Fax Drivers for Linux'
  homepage 'https://developers.hp.com/hp-linux-imaging-and-printing/'
  version '3.18.7'
  source_url 'https://sourceforge.net/projects/hplip/files/hplip/3.18.7/hplip-3.18.7.tar.gz'
  source_sha256 '55b879e1d6d0d88c32d79486b748a21759cab404036d883be4ea9fcb55bfeb1d'

  binary_url ({
  })
  binary_sha256 ({
  })

  depends_on 'libjpeg'
  depends_on 'cups'

  def self.build
    system "sed -i 's,/usr/bin/perl,#{CREW_PREFIX}/bin/perl,g' hpijs-drv"
    system "sed -i 's,/usr/include,#{CREW_PREFIX}/include,g' Makefile.in Makefile.am config.guess installer/core_install.py installer/dcheck.py"
    system 'sed -i "s,return(true);,return TRUE;,g" prnt/hpcups/genPCLm.cpp'
    system 'sed -i "s,return true;,return TRUE;,g" prnt/hpcups/genPCLm.cpp'
    system "sed -i 's,/usr/bin/file,#{CREW_PREFIX}/bin/file,g' configure"
    system "./configure --disable-network-build --prefix=#{CREW_PREFIX} --libdir=#{CREW_LIB_PREFIX}"
    system 'make'
  end

  def self.install
    system "sed -i 's,/etc/sane.d,#{CREW_PREFIX}/etc/sane.d,g' Makefile"
    system "make DESTDIR=#{CREW_DEST_DIR} systraydir=#{CREW_PREFIX}/etc/xdg/autostart rulesdir=#{CREW_PREFIX}/etc/udev/rules.d hplip_confdir=#{CREW_PREFIX}/etc/hp cupsfilterdir=#{CREW_LIB_PREFIX}/cups/filter rulessystemdir=#{CREW_LIB_PREFIX}/systemd/system cupsbackenddir=#{CREW_LIB_PREFIX}/cups/backend mimedir=#{CREW_PREFIX}/share/cups/mime abs_mimedir=#{CREW_PREFIX}/share/cups/mime halpredir=#{CREW_PREFIX}/share/hal/fdi/preprobe/10osvendor icondir=#{CREW_PREFIX}/share/applications install"
  end
end
