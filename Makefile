# YOU MIGHT NEED TO COPY THIS HERE
# /homes/ggkitsas/Projects/ramdisk-hacking/uramdisk.image.gz

FILESYSTEM_ROOT=./ramdisk-mnt
RESOURCES_DIR=.
DRAFTS_DIR=./tmp/

all: new-ramdisk clean-ramdisk

mount-root: $(FILESYSTEM_ROOT)

$(FILESYSTEM_ROOT):
	./ramdisk.sh open $(OLD_RAMDISK)

clean-root:
	./ramdisk.sh close $(OLD_RAMDISK)
	rmdir $(FILESYSTEM_ROOT)

new-ramdisk: mount-root
	@echo "Building ramdisk..."
	dd if=/dev/zero of=$(RESOURCES_DIR)/ramdisk.img bs=1024 count=$$(($$(du -s $(FILESYSTEM_ROOT) | awk '{print $$1}') * 2))
	mke2fs -F $(RESOURCES_DIR)/ramdisk.img -L "ramdisk" -b 1024 -m 0
	tune2fs $(RESOURCES_DIR)/ramdisk.img -i 0
	mkdir $(DRAFTS_DIR)
	@echo "Sudo is used to mount ramdisk..."
	sudo mount -o loop $(RESOURCES_DIR)/ramdisk.img $(DRAFTS_DIR)
	sudo cp -R $(FILESYSTEM_ROOT)/* $(DRAFTS_DIR)

clean-ramdisk: clean-root
	sudo umount $(DRAFTS_DIR)
	rmdir $(DRAFTS_DIR)

test-ramdisk:
	mkdir -p $(FILESYSTEM_ROOT)
	sudo mount -o loop,rw ramdisk.img $(FILESYSTEM_ROOT)
