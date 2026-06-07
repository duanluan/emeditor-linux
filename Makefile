.PHONY: deb rpm appimage aur-source docker-rpm docker-appimage docker-packages clean

deb:
	./packaging/deb/build.sh

rpm:
	./packaging/rpm/build.sh

appimage:
	./packaging/appimage/build.sh

aur-source:
	./packaging/arch/prepare-aur-source.sh

docker-rpm:
	./packaging/docker/build-rpm.sh

docker-appimage:
	./packaging/docker/build-appimage.sh

docker-packages: docker-rpm docker-appimage

clean:
	rm -rf build dist
