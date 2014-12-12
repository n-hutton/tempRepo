obj-m += chardev.o

all:
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules
	echo 'make -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules'
	@rm chardev.mod.c
	@rm chardev.mod.o
	@rm chardev.o
	@rm modules.order
	@rm Module.symvers

run: 
	@-sudo dmesg -c > /dev/null             # Clear kernel messages
	@-sudo rmmod chardev                    # in case already there
	@-sudo rm /dev/chardev                  # also in case
	sudo insmod chardev.ko
	sudo dmesg -c                          # Clear/show kernel messages
	sudo mknod /dev/chardev c 100 0 -m 777 # Add new driver - can echo to it fine with permission set to 777 (probably dangerous)
	@echo ""
	@echo "->Cat the driver"
	cat /dev/chardev
	@echo ""
	@echo "->Echo to the driver"
	@#echo -ne "Helloo~~\n" > /dev/chardev #This doesn't work as well as printf
	printf "Helloo~~\n" > /dev/chardev
	@echo ""
	@echo "->Cat the driver again"
	cat /dev/chardev
	@echo ""
	@echo "->Cat the driver one more time to see if there is anything there"
	cat /dev/chardev

clean:
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) clean


