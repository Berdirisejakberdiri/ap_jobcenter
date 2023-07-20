Config = {}
Config.Lang = 'ID' -- Tersedia EN dan ID

Config.ShowBlipJobCenter = true -- Jika di setel false, maka akan menghilangkan blip lokasi job center pada map
Config.ShowBlipGarasi = true -- Jika di setel false, maka akan menghilangkan blip lokasi garasi job pada map

Config.apJobcenter = {
    position = vector4(-266.71, -961.0, 31.22, 200.91), -- Lokasi PED JOB CENTER
    garasiPosition = vector4(-293.41, -986.56, 31.08, 74.85), -- Lokasi PED GARASI
    Spawnveh = vector4(-301.09, -988.58, 30.71, 339.04), -- Lokasi Spawn Kendaraan
    pedModel = `a_f_y_business_01`, -- PED JOB CENTER (https://docs.fivem.net/docs/game-references/ped-models/)
    pedGarasi = `a_m_y_eastsa_01`, -- PED GARASI (https://docs.fivem.net/docs/game-references/ped-models/)
    ShowDebug = false -- Jangan disentuh, ini khusus untuk Developer
}

Config.Jobs = {
    unemployed = { -- Sesuaikan dengan jobs name pada database server anda
        vehJob = 'bison', -- Kendaraan untuk pekerjaan ini
        TextJob = " ", -- Deskripsi Untuk job ini (Gunakan menggunakan bahasa anda)
        images = "https://i.imgur.com/5oTBeo8.jpeg", -- Contoh Ukuran : 464 X 500
        waypointKantor = vector3(1217.92, -1266.96, 36.42), -- Ubah lokasi kantor sesuai server anda
        waypointToko = vector3(1217.92, -1266.96, 36.42), -- Ubah lokasi toko sesuai server anda
        waypointKerja = vector3(-516.87, 5332.09, 80.26) -- Ubah lokasi kerja sesuai server anda
    },

    lumberjack = {
        vehJob = 'bison',
        TextJob = "Dalam pekerjaan ini, \n kamu harus memiliki pengetahuan tentang kayu, penggunaan alat-alat kayu, dan proses pembuatan produk kayu. Kamu juga harus berinteraksi dengan warga lain untuk menjual produk kayu kamu.",
        images = "https://i.imgur.com/BoKI1YO.jpeg",
        waypointKantor = vector3(1217.92, -1266.96, 36.42),
        waypointToko = vector3(1217.92, -1266.96, 36.42),
        waypointKerja = vector3(-516.87, 5332.09, 80.26)
    },

    fueler = {
        vehJob = 'rebel',
        TextJob = "Dalam pekerjaan ini, \n kamu harus memiliki pengetahuan tentang kayu, penggunaan alat-alat kayu, dan proses pembuatan produk kayu. Kamu juga harus berinteraksi dengan warga lain untuk menjual produk kayu kamu.",
        images = "https://i.imgur.com/1liNvFP.jpeg",
        waypointKantor = vec3(716.71, 2526.96, 73.51),
        waypointToko = vec3(716.71, 2526.96, 73.51),
        waypointKerja = vec3(716.71, 2526.96, 73.51)
    },

    miner = {
        vehJob = 'tiptruck',
        TextJob = "Dalam pekerjaan ini, \n kamu harus memiliki pengetahuan tentang kayu, penggunaan alat-alat kayu, dan proses pembuatan produk kayu. Kamu juga harus berinteraksi dengan warga lain untuk menjual produk kayu kamu.",
        images = "https://i.imgur.com/wO0iOlb.jpg",
        waypointKantor = vec3(716.71, 2526.96, 73.51),
        waypointToko = vec3(716.71, 2526.96, 73.51),
        waypointKerja = vec3(716.71, 2526.96, 73.51)
    },

    slaughterer = {
        vehJob = 'mule3',
        TextJob = "Dalam pekerjaan ini, \n kamu harus memiliki pengetahuan tentang kayu, penggunaan alat-alat kayu, dan proses pembuatan produk kayu. Kamu juga harus berinteraksi dengan warga lain untuk menjual produk kayu kamu.",
        images = "https://i.imgur.com/OzXQ3h1.jpeg",
        waypointKantor = vector3(2434.63, 5011.93, 46.84),
        waypointToko = vector3(2377.93, 5053.37, 46.44),
        waypointKerja = vector3(-98.19, 6210.47, 31.03)
    },
    
    busdriver = {
        vehJob = 'bus',
        TextJob = "Dalam pekerjaan ini, \n kamu harus memiliki pengetahuan tentang kayu, penggunaan alat-alat kayu, dan proses pembuatan produk kayu. Kamu juga harus berinteraksi dengan warga lain untuk menjual produk kayu kamu.",
        images = "https://i.imgur.com/zlG9JIp.jpeg",
        waypointKantor = vec3(716.71, 2526.96, 73.51),
        waypointToko = vec3(716.71, 2526.96, 73.51),
        waypointKerja = vec3(716.71, 2526.96, 73.51)
    },

    tailor = {
        vehJob = 'youga2',
        TextJob = "Dalam pekerjaan ini, \n kamu harus memiliki pengetahuan tentang kayu, penggunaan alat-alat kayu, dan proses pembuatan produk kayu. Kamu juga harus berinteraksi dengan warga lain untuk menjual produk kayu kamu.",
        images = "https://i.imgur.com/e9N2hdP.jpeg",
        waypointKantor = vec3(716.71, 2526.96, 73.51),
        waypointToko = vec3(716.71, 2526.96, 73.51),
        waypointKerja = vec3(716.71, 2526.96, 73.51)
    },
}

RegisterNetEvent('ap_jobcenter:notify')
AddEventHandler('ap_jobcenter:notify', function(message, type, time)	
    -- -- ## Masukan Notifikasi Sesuai Yang Anda Gunakan ##
    lib.notify({ -- Default OX Notify
        title = 'AP JOB CENTER',
        description = message,
        position = 'top',
        type = type,
        duration = time
    })
    -- -- ## Jika Anda Menggunakan [mythic_notify] ##
    -- exports['mythic_notify']:SendAlert(type, message)
end)


Config.String = {
    ['ID'] = { -- Bahasa Indonesia
		-- Blips
		namablip1 = 'Job center',
        namablip2 = 'Garasi Pekerja',

        -- Target
		listjob = 'Daftar Pekerjaan',
        parkir = 'Masukan Kendaraan',

        -- Notif
        jobnil = 'Silahkan Mengambil Pekerjaan Terlebih Dahulu',
        vehkeluar = 'Kendaraan Kerja berhasil dikeluarkan.  \n Plat :',
        bloklok = 'Lokasi Parkiran Terhalangi!',
        blokdouble = 'Anda belum mengembalikan kendaraan sebelumnya!',
        notvehjob = 'Bukan Kendaraan Kerja!',
        vehrelease = 'Kendaraan Berhasil Dimasukan',
        notveh = 'Tidak Menemukan Kendaraan!',
        ambilkerja = 'Berhasil mengambil pekerjaan :  \n',
        setgps = '  \n berhasil di tandai, silahkan cek GPS kamu.',
        kantor = 'Kantor',
        toko = 'Toko Peralatan',
        lokjob = 'Tempat Kerja',

        -- Menu
        descjob = 'Klik untuk melihat detail pekerjaan',
        gaji = 'Gaji permenit ',
        pilihkerja = 'Pilih Pekerjaan',
        infojob = 'Info Pekerjaan',
        pekerjaan = 'Pekerjaan',
        klikgps = 'Klik untuk menandai lokasi pada GPS',
        lokkantor = 'Lokasi Kantor',
        lokshop = 'Lokasi Toko Peralatan',
        lokkerja = 'Lokasi Kerja',
        infos = 'Informasi',

        -- debug
        spawnped1 = 'Ped Daftar pekerjaan Dimunculkan',
        spawnped2 = 'Ped Garasi Dimunculkan',
        deleteped1 = 'Ped Daftar Pekerjaan Dihilangkan',
        deleteped2 = 'Ped Garasi Dihilangkan',
	},

    ['EN'] = { -- English
		-- Blips
		namablip1 = 'Jobs Center',
        namablip2 = 'Worker\'s Garage',

        -- Target
		listjob = 'Job Center',
        parkir = 'Return Vehicle',

        -- Notif
        jobnil = 'You have to take a job first',
        vehkeluar = 'Work Vehicle successfully parked.  \n Plate :',
        bloklok = 'Parking area is full!',
        blokdouble = 'You haven\'t returned the previous vehicle!',
        notvehjob = 'Not a Work Vehicle!',
        vehrelease = 'Vehicle Returned Successfully',
        notveh = 'No Vehicle Found!',
        ambilkerja = 'Successfully selected a job :  \n',
        setgps = '  \n marked successfully, please check your GPS.',
        kantor = 'Office',
        toko = 'Equipment Store',
        lokjob = 'Workplace',

        -- Menu
        descjob = 'Click to view job details',
        gaji = 'Salary per minute',
        pilihkerja = 'Select Jobs',
        infojob = 'Job Info',
        pekerjaan = 'Jobs',
        klikgps = 'Click to mark a location on GPS',
        lokkantor = 'Office Location',
        lokshop = 'Equipment Store Locations',
        lokkerja = 'Work location',
        infos = 'Information',

        -- debug
        spawnped1 = 'Spawn Ped Job center',
        spawnped2 = 'Spawn Ped Garage',
        deleteped1 = 'Delete Ped Job center',
        deleteped2 = 'Delete Ped Garage',
	},
}