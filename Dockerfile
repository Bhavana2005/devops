# Use Node.js Alpine base image
FROM node:alpine

# Set working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json
COPY package.json package-lock.json /app/

# Install dependencies
RUN npm install

# Copy the entire project to the working directory
COPY . /app/

# Build the React app for production
RUN npm run build

# Serve the built React app using Nginx
FROM nginx:alpine

# Set working directory
WORKDIR /usr/share/nginx/html

# Remove default Nginx static files
RUN rm -rf ./*

# Copy the React build files
COPY --from=0 /app/build .

# Copy form.html to serve separately
COPY public/form.html /usr/share/nginx/html/form.html

# Expose the correct port
EXPOSE 3001

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
