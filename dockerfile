# Use the Nginx base image
FROM nginx:alpine

# Set the working directory in the container
WORKDIR /usr/share/nginx/html

# Copy the contents of your HTML project to the container
COPY . .
#Trigger it
# Expose port 8080 for HTTP traffic
EXPOSE 8080

# Modify the Nginx configuration to listen on port 8080
RUN sed -i 's/listen       80;/listen       8080;/' /etc/nginx/conf.d/default.conf

# Start the Nginx server when the container launches
CMD ["nginx", "-g", "daemon off;"]