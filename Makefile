.PHONY: build serve new publish publish-pages publish-source clean

# Build the site
build:
	hugo

# Run development server
serve:
	hugo server

# Create new post (usage: make new POST=my-post-name)
new:
	@if [ -z "$(POST)" ]; then \
		echo "Usage: make new POST=post-name"; \
		exit 1; \
	fi
	hugo new posts/$(POST).md

# Publish both GitHub Pages and source code
publish: build publish-pages publish-source
	@echo "Successfully published!"

# Publish to GitHub Pages (public directory)
publish-pages:
	@echo "Publishing to GitHub Pages..."
	cd public && \
	git add . && \
	git commit -m "update" && \
	git push

# Publish source code to main repository
publish-source:
	@echo "Publishing source code..."
	git add . && \
	git commit -m "update" && \
	git push

# Clean generated files
clean:
	rm -rf public/*
	rm -rf resources/_gen
	rm -f .hugo_build.lock
