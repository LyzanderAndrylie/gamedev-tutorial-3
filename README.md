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

    Berikut adalah kode implementasinya.

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
