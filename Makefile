.PHONY: deb rpm appimage aur-source docker-deb docker-rpm docker-appimage docker-packages clean

deb:
	./packaging/deb/build.sh

rpm:
	./packaging/rpm/build.sh

appimage:
	./packaging/appimage/build.sh

aur-source:
	./packaging/arch/prepare-aur-source.sh

docker-deb:
	./packaging/docker/build-deb.sh

docker-rpm:
	./packaging/docker/build-rpm.sh

docker-appimage:
	./packaging/docker/build-appimage.sh

docker-packages: docker-deb docker-rpm docker-appimage

clean:
	rm -rf build dist
