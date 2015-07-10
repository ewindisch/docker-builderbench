alias docker="/home/ubuntu/docker/bundles/1.8.0-dev/binary/docker"
function time_docker {
	time docker build -f Dockerfile.tmp - < $1 >/dev/null
}

echo "Copy 100 tars (1M)"
(
	echo "FROM scratch"
	for n in {1..100}; do echo "COPY test.tar /$n"; done
) > Dockerfile.tmp
time_docker <(tar c Dockerfile.tmp test.tar)

echo "Extract 100 tars (1M)"
(
	echo "FROM scratch"
	for n in {1..100}; do echo "ADD test.tar /$n"; done
) > Dockerfile.tmp
time_docker <(tar c Dockerfile.tmp test.tar)

echo "Extract 100 tar-gzips (1M uncompressed)"
(
	echo "FROM scratch"
	for n in {1..100}; do echo "ADD test.tar.gz /$n"; done
) > Dockerfile.tmp
time_docker <(tar c Dockerfile.tmp test.tar.gz)

echo "Extract 1 big tar-gzip (1GB uncompressed)"
(
	echo "FROM scratch"
	echo "ADD bigtest.tar.gz /"
) > Dockerfile.tmp
time_docker <(tar c Dockerfile.tmp bigtest.tar.gz)
