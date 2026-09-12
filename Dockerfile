# Static portfolio served by nginx on Fly.io.
# Only the published surface is copied: working documents (HANDOFF.md, docs/,
# upwork/) stay in the repo but never reach the image.
FROM nginx:1.27-alpine

COPY index.html /usr/share/nginx/html/
COPY assets/ /usr/share/nginx/html/assets/
COPY case-studies/ /usr/share/nginx/html/case-studies/
COPY deploy/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 8080
