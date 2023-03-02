import { initializeApp } from "firebase/app";
import { getAnalytics } from "firebase/analytics";
export let analytics: any;
export default {
    init: () => {
        const firebaseConfig = {
            apiKey: "AIzaSyDeXz7W4TgJr7qcA9f5GeQ04RrOpz-dces",
            authDomain: "mado-website-f20f8.firebaseapp.com",
            projectId: "mado-website-f20f8",
            storageBucket: "mado-website-f20f8.appspot.com",
            messagingSenderId: "460973368501",
            appId: "1:460973368501:web:7a5e19315cd3d555890afc",
            measurementId: "G-K11C7JD3ZM"
        };

        const app = initializeApp(firebaseConfig);
        analytics = getAnalytics(app);
    }
}