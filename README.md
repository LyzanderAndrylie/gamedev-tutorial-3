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
