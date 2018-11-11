xorriso -as mkisofs \
    -iso-level 3 \
    -full-iso9660-filenames \
    -volid "SIMON_LINUX" \
    -eltorito-boot isolinux/isolinux.bin \
    -eltorito\-catalog isolinux/boot.cat \
    -no-emul-boot -boot-load-size 4 -boot-info-table \
    -isohybrid-mbr /mnt/customiso/arch/isolinux/isohdpfx.bin \
    -eltorito-alt-boot \
    -e EFI/archiso/efiboot.img \
    -no-emul-boot -isohybrid-gpt-basdat \
    -output arch-simon-linux-$(date "+%y.%m.%d")-dual.iso arch

