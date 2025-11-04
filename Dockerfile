# On part de l'image de base qui fournit Node.js et un WORKDIR /app
FROM whanos-javascript

# 1. On copie les fichiers de configuration
COPY package*.json ./
COPY tsconfig.json ./

# 2. On installe les dépendances listées dans package.json (comme "express")
# On n'installe que les dépendances de production pour alléger l'image
RUN npm install --only=production

# 3. On copie le code source de l'application (le dossier "app")
COPY app ./app

# 4. On installe TypeScript temporairement, juste pour la compilation
RUN npm install typescript@4.4.3

# 5. MAINTENANT on peut compiler. tsc va lire tsconfig.json et compiler les fichiers .ts dans le dossier app
# On utilise npx pour être sûr d'exécuter la version locale de tsc
RUN npx tsc

# 6. On nettoie les fichiers TypeScript source, on ne garde que les .js compilés
RUN find . -name "*.ts" -type f -not -path "./node_modules/*" -delete

# 7. (TRÈS IMPORTANT) On définit comment lancer l'application compilée
# Votre package.json indique que le point d'entrée est "app/app.js"
CMD ["node", "app/app.js"]