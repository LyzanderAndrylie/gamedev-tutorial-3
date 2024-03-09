# Tutorial 2 - Game Development 2023/2024

> Godot Version: 3.5.3

## Latihan Mandiri: Eksplorasi Mekanika Pergerakan

Fitur lanjutan terkait dengan mekanika pergerakan karakter di game *platformer* adalah sebagai berikut.

1. Double Jump

    Pergerakan *double jump* memungkinkan pemain untuk bisa melakukan aksi loncat sebanyak dua kali. Implementasi pergerakan ini adalah sebagai berikut.

    - Memanfaatkan private variabel `var jump_count = 0` untuk menghitung jumlah lompatan yang telah dilakukan oleh *scene* `Player`
    - Ketika kita menekan tombol "up", *scene* `Player` perlu mengecek jumlah `jump_count` apakah `jump_count < 2`.
      - Jika iya, `velocity.y = jump_speed` diterapkan dengan `velocity` adalah vector arah (x, y) dan `jump_speed` menentukan kecepatan lompat. Selain itu, kita harus menambahkan `jump_count` yang telah dilakukan dengan menggunakan `jump_count += 1`.
    - Ketika *scene* `Player` berada di `floor`, kita harus men-*reset* `jump_count` menjadi 0 agar dapat melakukan *jump* dan/atau *double jump* lagi.

    Berikut adalah kode implementasinya dengan komen.

    ```py
    extends KinematicBody2D

    export (int) var speed = 400
    export (int) var GRAVITY = 1200
    export (int) var jump_speed = -600

    var velocity = Vector2()
    const UP = Vector2(0,-1)
    var jump_count = 0 # Tambahan: private variable untuk menghitung jumlah jump yang telah dilakukan

    func get_input():
        velocity.x = 0
        
        double_jump()
        
        ...

    # Tambahan: fungsi yang memungkinkan implementasi double jump
    func double_jump():
        if is_on_floor():
            jump_count = 0
        if Input.is_action_just_pressed('up') and jump_count < 2:
            velocity.y = jump_speed
            jump_count += 1

    func _physics_process(delta):
        velocity.y += delta * GRAVITY
        get_input()
        velocity = move_and_slide(velocity, UP)

    ```

2. Dashing

    Pergerakan *dashing* memungkinkan pemain untuk bisa dapat bergerak lebih cepat dari kecepatan biasa secara sementara ketika pemain menekan tombol arah sebanyak dua kali. Implementasi pergerakan ini adalah sebagai berikut.

    - Ketika pemain menekan (*press*) dan kemudian melepaskan (*release*) tombol "left" atau "right", dash ke arah *left/right* akan aktif dalam selang waktu tertentu (mis: 0.1 detik).

      - Jika pemain menekan kembali tombol yang telah ditekan, maka pergerakan *dash* akan aktif.
      - Jika tidak, pergerakan *dash* akan nonaktif.

    - Ketika pemain telah melakukan pergerakan dash,       terdapat cooldown untuk pergerakan tersebut selama selang waktu tertentu (mis: 0.75 detik).

    Berikut adalah kode implementasinya dengan komen.

    ```py
    export (int) var dash_multiplier = 20

    const DASH_ACTIVE_TIME = 0.1
    const DASH_COOLDOWN_TIME = 0.5
    var current_dash_active_time = 0
    var current_dash_cooldown_time = 0
    var right_dash_enable = false
    var left_dash_enable = false

    func get_input():
        velocity.x = 0
        
        dash()
    
        ...


    func dash():
        # enable dash ke arah kanan
        if Input.is_action_just_released('right') and current_dash_cooldown_time == 0:
            right_dash_enable = true
            left_dash_enable = false
            current_dash_active_time = DASH_ACTIVE_TIME

        # enable dash ke arah kiri
        if Input.is_action_just_released('left') and current_dash_cooldown_time == 0:
            left_dash_enable = true
            right_dash_enable = false
            current_dash_active_time = DASH_ACTIVE_TIME
        
        # mengaktifkan dash ke arah kanan
        if Input.is_action_just_pressed("right") and right_dash_enable and current_dash_active_time > 0:
            velocity.x = 0
            velocity.x += speed * dash_multiplier
            right_dash_enable = false
            current_dash_cooldown_time = DASH_COOLDOWN_TIME
        
        # mengaktifkan dash ke arah kiri
        if Input.is_action_just_pressed("left") and left_dash_enable and current_dash_active_time > 0:
            velocity.x = 0
            velocity.x -= speed * dash_multiplier
            left_dash_enable = false
            current_dash_cooldown_time = DASH_COOLDOWN_TIME

    func _physics_process(delta):
        velocity.y += delta * GRAVITY

        # Tambahan: Menyesuaikan waktu dash active
        current_dash_active_time = current_dash_active_time - delta if current_dash_active_time > 0 else 0 
       
        # Tambahan: Menyesuaikan waktu dash cooldown
        current_dash_cooldown_time = current_dash_cooldown_time - delta if current_dash_cooldown_time > 0 else 0 
        get_input()
        velocity = move_and_slide(velocity, UP)
        
    ```

3. Crouching

    Pergerakan *crouching* memungkinkan pemain untuk bisa dapat jongkok dimana sprite-nya terlihat lebih kecil  dan kecepatan pergerakannya menjadi lebih lambat ketika lagi jongkok. Implementasi pergerakan ini adalah sebagai berikut.

    - Ketika pemain menekan tombol "crouch" (ALT atau SHIFT), kecepatan pergerakan pemain pada sumbu x harus dikurangkan, misalnya dibagi dengan 2. Dengan demikian, pergerakan karakter akan menjadi lebih lambat ketika *crouch*.

    Berikut adalah kode implementasinya dengan komen.

    ```py
    var crouch_active = false

    func get_input():
        velocity.x = 0
        
        crouch()
    
        ...


    func crouch():
        if Input.is_action_pressed("crouch"):
            # Pengurangan velocity x menjadi setengahnya ketika tombol "crouch" ditekan
            velocity.x = velocity.x / 2 
            crouch_active = true
            $Sprite.texture = load("res://assets/kenney_platformercharacters/PNG/Player/Poses/player_duck.png")

        if Input.is_action_just_released("crouch"):
            crouch_active = false
            $Sprite.texture = load("res://assets/kenney_platformercharacters/PNG/Player/Poses/player_idle.png")
    ```

## Sumber Referensi

1. [Godot Tutorial - How to Print any variable to screen](https://www.youtube.com/watch?v=NLpWkpZ_mCo)
2. [how to change sprite from code](https://forum.godotengine.org/t/how-to-change-sprite-from-code/14939)

<hr>

# Tutorial 5 - Game Development 2023/2024

## Latihan Mandiri: Membuat dan Menambah Variasi Aset

Silakan eksplorasi lebih lanjut mengenai animasi berdasarkan spritesheet dan audio. Untuk latihan mandiri yang dikerjakan di akhir tutorial, kamu diharapkan untuk:

1. Membuat minimal 1 (satu) objek baru di dalam permainan yang dilengkapi dengan animasi menggunakan spritesheet selain yang disediakan tutorial.

    Implementasi ini dapat dilakukan dengan memperoleh asset baru dari internet, seperti <https://www.kenney.nl/assets/toon-characters-1>, dan membuat *scene* `KinematicBody2D` baru yang terdiri atas *node* `AnimatedSprite` dengan asset baru tersebut dan `CollisionShape2D`.

2. Membuat minimal 1 (satu) audio untuk efek suara (SFX) dan memasukkannya ke dalam permainan. Kamu dapat membuatnya sendiri atau mencari dari koleksi aset gratis.

    Implementasi ini dapat dilakukan dengan memperoleh asset audio dari internet, seperti <https://pixabay.com/id/sound-effects/cartoon-jump-6462/>, dan kemudian memasukkannya ke dalam permainan dengan memanfaatkan *scene* `AudioStreamPlayer2D`. Dalam implementasi yang saya lakukan, saya menambahkan SFX ketika *scene* `Player` melompat. Hal ini dapat dilakukan dengan memainkan audio tersebut melalui godot script ketika *scene* `Player` melakukan lompatan. Implementasi hal tersebut adalah sebagai berikut.

    ```py
    func double_jump():
        if is_on_floor():
            jump_count = 0
            $AnimatedSprite.play("diri_kanan")
        if Input.is_action_just_pressed("up") and jump_count < max_jump:
            velocity.y = jump_speed
            jump_count += 1
            $AnimatedSprite.play("lompat_kanan")
            $AudioStreamPlayer2D.play() # Tambahan: memainkan audio ketika pemain melompat
    ```

3. Membuat minimal 1 (satu) musik latar (background music) dan memasukkannya ke dalam permainan. Kamu dapat membuatnya sendiri atau mencari dari koleksi aset gratis.

    Implementasi ini dapat dilakukan dengan memperoleh asset background music dari internet dan kemudian memasukkannya ke dalam permainan dengan memanfaatkan *scene* `AudioStreamPlayer2D` sebagai child dari *root node* dan mengatur properti `Autoplay` dengan mencentang tombol `On`. Karena background music dari *tutorial* sudah oke, saya tidak mengganti background music tersebut.

4. Implementasikan interaksi antara objek baru tersebut dengan objek yang dikendalikan pemain. Misalnya, pemain dapat menciptakan atau menghilangkan objek baru tersebut ketika menekan suatu tombol atau tabrakan dengan objek lain di dunia permainan.

    Implementasi interaksi antara objek baru tersebut dengan objek yang dikendalikan oleh pemain adalah ketika pemain bertabrakan dengan objek baru tersebut, pemain akan mental. Implementasi dilakukan dengan menambahkan kode berikut. Secara sederhana, ketika terjadi tabrakan dengan *scene* `Zombie`, arah `Vector2D` terhadap sumbu x atau y tinggal dibalik (menjadi negatif). Selain itu, untuk mengatasi *bounce* terhadap sumbu x, `velocity.x` harus diperbesar agar memiliki efek yang lebih terasa.

    ```py
    func _physics_process(delta):
        velocity.y += delta * GRAVITY
        
        current_dash_active_time = (
            current_dash_active_time - delta
            if current_dash_active_time > 0
            else 0
        )
        current_dash_cooldown_time = (
            current_dash_cooldown_time - delta
            if current_dash_cooldown_time > 0
            else 0
        )
        get_input()
        
        var last_velocity = velocity
        velocity = move_and_slide(velocity, UP)
        
        var isCollide = false
        
        for i in get_slide_count():
            var collision = get_slide_collision(i)
            
            if collision.get_collider().name != 'Zombie':
                continue
            
            print("I collided with ", collision.get_collider().name)
            
            velocity = last_velocity.bounce(collision.normal)
            isCollide = true
            
            
        if isCollide:
            velocity.x *= 5
            velocity = move_and_slide(velocity, UP)
    ```

5. Implementasikan audio feedback dari interaksi antara objek baru dengan objek pemain. Misalnya, muncul efek suara ketika pemain tabrakan dengan objek baru.

    Implementasi ini dapat dilakukan dengan menambahkan *node* `Audio2DStreamPlayer2D` dengan audio dari <https://pixabay.com/id/sound-effects/search/hurt/> pada *scene* `Player` dan kemudian memainkannya ketika terjadi tabrakan antara `Player` tersebut dengan `Zombie`. Implementasi hal tersebut adalah sebagai berikut.

    ```py
    if isCollide:
        velocity.x *= 5
        velocity = move_and_slide(velocity, UP)
        $Ough.play()
    ```

6. Implementasi sistem audio yang relatif terhadap posisi objek. Misalnya, musik latar akan semakin terdengar samar ketika pemain semakin jauh dari posisi awal level.

    Implementasi hal ini dapat dilakukan dengan menambahkan *node* `Audio2DStreamPlayer2D` pada suatu objek, seperti `Zombie`, dan kemudian mengatur properti, seperti `Max Distance` dan `Attenuation` dari `Audio2DStreamPlayer2D` pada objek tersebut. Kemudian, untuk mengimplemnetasikan audio dari `Zombie` yang relatif terhadap posisi `Player`, kita harus menambahkan node `Camera2D` di untuk objek `Player` tersebut. Dengan demikian, audio yang bersifat relatif bedasarkan jarak dari `Player` dengan `Zombie` dapat diimplementasikan.

## Sumber Referensi

1. [Collision Detection dengan KinematicBody2D](https://random-game-project.blogspot.com/2021/05/collision-detection-dengan.html)
2. [`move_and_slide()` vs `move_and_collide()`](https://forum.godotengine.org/t/kinematicbody3d-move-and-slide-vs-move-and-collide-any-logic-in-different-input-and-output/23101/2)
3. [Detecting collisions](https://docs.godotengine.org/en/stable/tutorials/physics/using_character_body_2d.html#detecting-collisions)
4. [Get collider name with KinematicBody](https://forum.godotengine.org/t/get-collider-name-with-kinematicbody/22569/2)
