FROM nginx:alpine

# Set the working directory in the container
WORKDIR /usr/share/nginx/html

# Copy the contents of your HTML project to the container
COPY . .

# Expose port 80 for HTTP traffic
EXPOSE 80

# Start the Nginx server when the container launches
CMD ["nginx", "-g", "daemon off;"]