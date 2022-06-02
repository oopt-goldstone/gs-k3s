coredns:
	DOCKER_BUILDKIT=1 docker build -f docker/coredns.Dockerfile -t ghcr.io/oopt-goldstone/coredns:latest .
